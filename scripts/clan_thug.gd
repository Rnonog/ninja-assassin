class_name ClanThug
extends CharacterBody2D

enum Phase { CHASE, TELEGRAPH, ACTIVE, PAUSE, DEAD }

const THUG_SPEED := 150.0
const THUG_STAB_RANGE := 48.0
const THUG_TELEGRAPH := 0.35
const THUG_ACTIVE := 0.12
const THUG_PAUSE := 0.7
const HITBOX_SIZE := Vector2(48, 32)
const HITBOX_FORWARD := 12.0
const COLOR_IDLE := Color(0.95, 0.42, 0.22, 1)
const COLOR_BAND := Color(1.0, 0.82, 0.28, 1)
const COLOR_OUTLINE := Color(0.96, 0.95, 0.9, 1)
const COLOR_TELEGRAPH := Color(0.92, 0.72, 0.12, 1)
const COLOR_SWIPE := Color(0.78, 0.14, 0.12, 1)
const OUTLINE_GROW := 4.0

@export var auto_aggro: bool = true
@export var facing: int = -1

var health: Health
var phase: Phase = Phase.CHASE
var is_dead: bool = false

var _hitbox: Hitbox
var _body: ColorRect
var _hit_visual: ColorRect
var _hit_shape: CollisionShape2D
var _timer: float = 0.0
var _hurt_flash_timer: float = 0.0


func _ready() -> void:
	add_to_group("enemy")
	health = get_node_or_null("Health") as Health
	_hitbox = get_node_or_null("Hitbox") as Hitbox
	_body = get_node_or_null("Body") as ColorRect
	if health:
		health.max_hp = Health.THUG_MAX_HP
		health.current = Health.THUG_MAX_HP
		health.died.connect(_on_died)
		health.damaged.connect(_on_damaged)
	if _hitbox:
		_hit_visual = _hitbox.get_node_or_null("Visual") as ColorRect
		_hit_shape = _hitbox.get_node_or_null("CollisionShape2D") as CollisionShape2D
		_hitbox.team = &"enemy"
		_hitbox.damage = Health.THUG_DAMAGE
		_hitbox.collision_layer = 64
		_hitbox.collision_mask = 2
		_hitbox.set_active(false)
	var hurtbox := get_node_or_null("Hurtbox") as Area2D
	if hurtbox:
		hurtbox.collision_layer = 32
		hurtbox.collision_mask = 0
		hurtbox.team = &"enemy"
	collision_layer = 32
	collision_mask = 1
	_enter_phase(Phase.CHASE)


func request_stab() -> void:
	if is_dead:
		return
	if phase == Phase.TELEGRAPH or phase == Phase.ACTIVE:
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
	_sync_hitbox_transform()

	if not is_on_floor():
		velocity.y += _gravity() * delta

	if is_dead:
		velocity.x = 0.0
		move_and_slide()
		return

	match phase:
		Phase.CHASE:
			_tick_chase(delta)
		Phase.TELEGRAPH, Phase.ACTIVE, Phase.PAUSE:
			velocity.x = 0.0
			_timer -= delta
			if _timer <= 0.0:
				_advance_phase()
		Phase.DEAD:
			velocity.x = 0.0

	move_and_slide()


func _tick_chase(_delta: float) -> void:
	if not auto_aggro:
		velocity.x = 0.0
		return
	var target := _find_player()
	if target == null:
		velocity.x = 0.0
		return
	_face_player()
	var dx := target.global_position.x - global_position.x
	if absf(dx) <= THUG_STAB_RANGE:
		velocity.x = 0.0
		request_stab()
		return
	velocity.x = signf(dx) * THUG_SPEED


func _advance_phase() -> void:
	match phase:
		Phase.TELEGRAPH:
			_enter_phase(Phase.ACTIVE)
		Phase.ACTIVE:
			_enter_phase(Phase.PAUSE)
		Phase.PAUSE:
			_enter_phase(Phase.CHASE)


func _enter_phase(next: Phase) -> void:
	phase = next
	match next:
		Phase.CHASE:
			_timer = 0.0
			_set_hitbox_active(false)
		Phase.TELEGRAPH:
			_timer = THUG_TELEGRAPH
			_face_player()
			_set_hitbox_active(false)
		Phase.ACTIVE:
			_timer = THUG_ACTIVE
			_set_hitbox_active(true)
		Phase.PAUSE:
			_timer = THUG_PAUSE
			_set_hitbox_active(false)
		Phase.DEAD:
			_timer = 0.0
			_set_hitbox_active(false)
			velocity = Vector2.ZERO
	_apply_body_color()
	_update_hit_visual()


func _set_hitbox_active(on: bool) -> void:
	if _hitbox:
		_hitbox.set_active(on)
	_update_hit_visual()


func _sync_hitbox_transform() -> void:
	if _hitbox == null:
		return
	var dir := -1 if facing < 0 else 1
	_hitbox.position = Vector2(float(dir) * HITBOX_FORWARD, 0.0)
	if _hit_shape and _hit_shape.shape is RectangleShape2D:
		(_hit_shape.shape as RectangleShape2D).size = HITBOX_SIZE
	if _hit_visual:
		_hit_visual.size = HITBOX_SIZE
		_hit_visual.position = -HITBOX_SIZE * 0.5


func _update_hit_visual() -> void:
	if _hit_visual:
		_hit_visual.visible = phase == Phase.ACTIVE


func _on_died() -> void:
	if is_dead:
		return
	is_dead = true
	_enter_phase(Phase.DEAD)


func _on_damaged(_amount: int, _remaining: int) -> void:
	_hurt_flash_timer = Health.HURT_FLASH_DURATION


func _apply_body_color() -> void:
	if _body == null:
		return
	if is_dead:
		_body.color = Color(0.22, 0.18, 0.16, 1)
		return
	if _hurt_flash_timer > 0.0:
		_body.color = Color(1.0, 0.45, 0.4, 1)
		return
	match phase:
		Phase.TELEGRAPH:
			_body.color = COLOR_TELEGRAPH
		Phase.ACTIVE:
			_body.color = COLOR_SWIPE
		_:
			_body.color = COLOR_IDLE
