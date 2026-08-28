class_name ThrowFighter
extends CharacterBody2D

enum Phase { IDLE, TELEGRAPH, RECOVERY, DEAD }

const THROWER_SPEED := 140.0
const THROWER_PREFERRED_DISTANCE := 220.0
const THROWER_DISTANCE_BAND := 40.0
const THROWER_TELEGRAPH := 0.45
const THROWER_THROW_RECOVERY := 0.6
const COLOR_IDLE := Color(0.28, 0.32, 0.42, 1)
const COLOR_TELEGRAPH := Color(0.92, 0.72, 0.12, 1)
const COLOR_THROW := Color(0.78, 0.14, 0.12, 1)

@export var auto_aggro: bool = true
@export var facing: int = -1

var health: Health
var phase: Phase = Phase.IDLE
var is_dead: bool = false

var _body: ColorRect
var _timer: float = 0.0
var _hurt_flash_timer: float = 0.0
var _throw_armed: bool = false


func _ready() -> void:
	add_to_group("enemy")
	health = get_node_or_null("Health") as Health
	_body = get_node_or_null("Body") as ColorRect
	if health:
		health.max_hp = Health.THROWER_MAX_HP
		health.current = Health.THROWER_MAX_HP
		health.died.connect(_on_died)
		health.damaged.connect(_on_damaged)
	var hurtbox := get_node_or_null("Hurtbox") as Area2D
	if hurtbox:
		hurtbox.collision_layer = 32
		hurtbox.collision_mask = 0
		hurtbox.team = &"enemy"
	collision_layer = 32
	collision_mask = 1
	_enter_phase(Phase.IDLE)


func request_throw_attack() -> void:
	if is_dead:
		return
	if phase == Phase.TELEGRAPH:
		return
	_enter_phase(Phase.TELEGRAPH)


func _find_player() -> Node2D:
	if not is_inside_tree():
		return null
	var nodes := get_tree().get_nodes_in_group("player")
	if nodes.is_empty():
		return null
	return nodes[0] as Node2D


func _face_player() -> void:
	var target := _find_player()
	if target == null:
		return
	var dx := target.global_position.x - global_position.x
	if absf(dx) > 1.0:
		facing = 1 if dx > 0.0 else -1


func _gravity() -> float:
	return float(ProjectSettings.get_setting("physics/2d/default_gravity"))


func _physics_process(delta: float) -> void:
	_hurt_flash_timer = maxf(_hurt_flash_timer - delta, 0.0)
	_apply_body_color()

	if not is_on_floor():
		velocity.y += _gravity() * delta

	if is_dead:
		velocity.x = 0.0
		move_and_slide()
		return

	match phase:
		Phase.IDLE:
			_tick_idle(delta)
		Phase.TELEGRAPH:
			velocity.x = 0.0
			_timer -= delta
			if _timer <= 0.0:
				_release_throw()
		Phase.RECOVERY:
			velocity.x = 0.0
			_timer -= delta
			if _timer <= 0.0:
				_enter_phase(Phase.IDLE)
		Phase.DEAD:
			velocity.x = 0.0

	move_and_slide()


func _tick_idle(_delta: float) -> void:
	if not auto_aggro:
		velocity.x = 0.0
		return
	var target := _find_player()
	if target == null:
		velocity.x = 0.0
		return
	var dx := target.global_position.x - global_position.x
	var dist := absf(dx)
	_face_player()
	if dist < THROWER_PREFERRED_DISTANCE - THROWER_DISTANCE_BAND:
		velocity.x = -signf(dx) * THROWER_SPEED
	elif dist > THROWER_PREFERRED_DISTANCE + THROWER_DISTANCE_BAND:
		velocity.x = signf(dx) * THROWER_SPEED
	else:
		velocity.x = 0.0
		request_throw_attack()


func _release_throw() -> void:
	if _throw_armed and not is_dead:
		_spawn_star()
	_throw_armed = false
	_enter_phase(Phase.RECOVERY)


func _spawn_star() -> void:
	var host := get_parent()
	if host == null:
		return
	var packed: PackedScene = load("res://scenes/shuriken.tscn")
	if packed == null:
		return
	var star := packed.instantiate()
	star.configure(&"enemy", Health.THROWER_DAMAGE, facing, Projectile.SHURIKEN_SPEED)
	host.add_child(star)
	star.global_position = global_position + Vector2(float(facing) * 20.0, 0.0)


func _enter_phase(next: Phase) -> void:
	phase = next
	match next:
		Phase.IDLE:
			_timer = 0.0
			_throw_armed = false
		Phase.TELEGRAPH:
			_timer = THROWER_TELEGRAPH
			_throw_armed = true
			_face_player()
		Phase.RECOVERY:
			_timer = THROWER_THROW_RECOVERY
			_throw_armed = false
		Phase.DEAD:
			_timer = 0.0
			_throw_armed = false
			velocity = Vector2.ZERO
	_apply_body_color()


func _interrupt_throw() -> void:
	if phase != Phase.TELEGRAPH:
		return
	_throw_armed = false
	_enter_phase(Phase.RECOVERY)


func _on_died() -> void:
	if is_dead:
		return
	is_dead = true
	_throw_armed = false
	_enter_phase(Phase.DEAD)


func _on_damaged(_amount: int, _remaining: int) -> void:
	_hurt_flash_timer = Health.HURT_FLASH_DURATION
	if phase == Phase.TELEGRAPH:
		_interrupt_throw()


func _apply_body_color() -> void:
	if _body == null:
		return
	if is_dead:
		_body.color = Color(0.18, 0.2, 0.24, 1)
		return
	if _hurt_flash_timer > 0.0:
		_body.color = Color(1.0, 0.45, 0.4, 1)
		return
	match phase:
		Phase.TELEGRAPH:
			_body.color = COLOR_TELEGRAPH
		Phase.RECOVERY:
			_body.color = COLOR_THROW
		_:
			_body.color = COLOR_IDLE
