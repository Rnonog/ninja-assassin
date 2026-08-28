class_name Player
extends CharacterBody2D

const SPEED := 180.0
const JUMP_VELOCITY := -420.0
const JUMP_CUT_MULTIPLIER := 0.45
const COYOTE_TIME := 0.1
const JUMP_BUFFER := 0.1
const DODGE_SPEED := 400.0
const DODGE_DURATION := 0.22
const DODGE_COOLDOWN := 0.3
const IFRAME_DURATION := 0.22
const DODGE_GRAVITY_SCALE := 0.25

const LIGHT_WINDUP := 0.04
const LIGHT_ACTIVE := 0.08
const LIGHT_RECOVERY := 0.16
const LIGHT_MOVE_SCALE := 0.35
const HEAVY_WINDUP := 0.22
const HEAVY_ACTIVE := 0.14
const HEAVY_RECOVERY := 0.28
const LIGHT_HITBOX_SIZE := Vector2(28, 24)
const HEAVY_HITBOX_SIZE := Vector2(44, 32)
const BODY_HALF_WIDTH := 16.0
const DEATH_RELOAD_DELAY := 2.0
const COMBO_ENABLED := true
const COMBO_FOLLOWUP_WINDOW := LIGHT_RECOVERY
const KATANA_MASK := 4 | 32

enum AttackKind { NONE, LIGHT, HEAVY }
enum AttackPhase { IDLE, WINDUP, ACTIVE, RECOVERY }

var invulnerable: bool = false
var facing: int = 1
var move_axis_override: Variant = null
var is_dead: bool = false
var attack_kind: AttackKind = AttackKind.NONE
var attack_phase: AttackPhase = AttackPhase.IDLE
var health: Health
var shuriken_ammo: int = 0

var _coyote_timer: float = 0.0
var _jump_buffer_timer: float = 0.0
var _dodge_timer: float = 0.0
var _dodge_cooldown_timer: float = 0.0
var _iframe_timer: float = 0.0
var _dodging: bool = false
var _jumped_this_frame: bool = false
var _attack_timer: float = 0.0
var _combo_lights: int = 0
var _combo_window: float = 0.0
var _hurt_flash_timer: float = 0.0
var _hitbox: Hitbox
var _hp_label: Label
var _ammo_label: Label
var _hit_visual: ColorRect
var _hit_shape: CollisionShape2D
var _reload_started: bool = false
var _sprite: AnimatedSprite2D = null


func _ready() -> void:
	_sprite = get_node_or_null("AnimatedSprite2D") as AnimatedSprite2D
	if _sprite != null and not _sprite.is_playing():
		_sprite.play("idle")
	health = get_node_or_null("Health") as Health
	_hitbox = get_node_or_null("Hitbox") as Hitbox
	_hp_label = get_node_or_null("HpLabel") as Label
	_ammo_label = get_node_or_null("AmmoLabel") as Label
	shuriken_ammo = Health.START_AMMO
	_update_ammo_label()
	if _hitbox:
		_hit_visual = _hitbox.get_node_or_null("Visual") as ColorRect
		_hit_shape = _hitbox.get_node_or_null("CollisionShape2D") as CollisionShape2D
		_hitbox.team = &"player"
		_hitbox.collision_layer = 8
		_hitbox.collision_mask = KATANA_MASK
		_hitbox.set_active(false)
	var hurtbox := get_node_or_null("Hurtbox") as Area2D
	if hurtbox:
		hurtbox.collision_layer = 2
		hurtbox.collision_mask = 0
		hurtbox.team = &"player"
	if health:
		health.died.connect(_on_died)
		health.damaged.connect(_on_damaged)
		_update_hp_label(health.current)
	add_to_group("player")


func set_move_axis(value: float) -> void:
	move_axis_override = clampf(value, -1.0, 1.0)


func request_jump() -> void:
	if is_dead:
		return
	if _heavy_rooted():
		return
	_jump_buffer_timer = JUMP_BUFFER


func release_jump() -> void:
	if velocity.y < 0.0:
		velocity.y *= JUMP_CUT_MULTIPLIER


func request_dodge() -> void:
	if is_dead:
		return
	if _dodging or _dodge_cooldown_timer > 0.0:
		return
	_cancel_attack()
	_dodging = true
	_dodge_timer = DODGE_DURATION
	_iframe_timer = IFRAME_DURATION
	invulnerable = true
	velocity.x = float(facing) * DODGE_SPEED


func request_attack_light() -> void:
	if is_dead or _dodging:
		return
	if _can_combo_light():
		_start_attack(AttackKind.LIGHT)
		return
	if attack_phase != AttackPhase.IDLE:
		return
	_combo_lights = 0
	_start_attack(AttackKind.LIGHT)


func request_attack_heavy() -> void:
	if is_dead or _dodging:
		return
	if _can_combo_heavy():
		_start_attack(AttackKind.HEAVY)
		return
	if attack_phase != AttackPhase.IDLE:
		return
	_combo_lights = 0
	_start_attack(AttackKind.HEAVY)


func request_throw() -> void:
	if is_dead or _dodging:
		return
	if _heavy_rooted():
		return
	if shuriken_ammo <= 0:
		return
	shuriken_ammo -= 1
	_update_ammo_label()
	var host := get_parent()
	if host == null:
		shuriken_ammo += 1
		_update_ammo_label()
		return
	var packed: PackedScene = load("res://scenes/shuriken.tscn")
	if packed == null:
		shuriken_ammo += 1
		_update_ammo_label()
		return
	var star := packed.instantiate()
	star.configure(&"player", Health.SHURIKEN_DAMAGE, facing, Projectile.SHURIKEN_SPEED)
	host.add_child(star)
	star.global_position = global_position + Vector2(float(facing) * (BODY_HALF_WIDTH + 8.0), 0.0)


func add_ammo(amount: int) -> void:
	if amount <= 0:
		return
	shuriken_ammo = mini(shuriken_ammo + amount, Health.MAX_AMMO)
	_update_ammo_label()


func heal(amount: int) -> void:
	if health == null:
		return
	health.heal(amount)
	_update_hp_label(health.current)


func _can_combo_light() -> bool:
	if not COMBO_ENABLED:
		return false
	if _combo_window <= 0.0 or _combo_lights != 1:
		return false
	return attack_phase == AttackPhase.RECOVERY or attack_phase == AttackPhase.IDLE


func _can_combo_heavy() -> bool:
	if not COMBO_ENABLED:
		return false
	if _combo_window <= 0.0 or _combo_lights < 1:
		return false
	return attack_phase == AttackPhase.RECOVERY or attack_phase == AttackPhase.IDLE


func _start_attack(kind: AttackKind) -> void:
	attack_kind = kind
	attack_phase = AttackPhase.WINDUP
	_attack_timer = LIGHT_WINDUP if kind == AttackKind.LIGHT else HEAVY_WINDUP
	if kind == AttackKind.HEAVY:
		_combo_window = 0.0
	_apply_hitbox_shape()
	_set_hitbox_active(false)
	if _attack_timer <= 0.0:
		_enter_attack_active()


func _cancel_attack() -> void:
	attack_kind = AttackKind.NONE
	attack_phase = AttackPhase.IDLE
	_attack_timer = 0.0
	_combo_window = 0.0
	_combo_lights = 0
	_set_hitbox_active(false)


func _enter_attack_active() -> void:
	attack_phase = AttackPhase.ACTIVE
	_attack_timer = LIGHT_ACTIVE if attack_kind == AttackKind.LIGHT else HEAVY_ACTIVE
	if _hitbox:
		_hitbox.damage = (
			Health.LIGHT_DAMAGE if attack_kind == AttackKind.LIGHT else Health.HEAVY_DAMAGE
		)
	_apply_hitbox_shape()
	_set_hitbox_active(true)


func _enter_attack_recovery() -> void:
	_set_hitbox_active(false)
	attack_phase = AttackPhase.RECOVERY
	if attack_kind == AttackKind.LIGHT:
		_attack_timer = LIGHT_RECOVERY
		_combo_lights = mini(_combo_lights + 1, 2)
		_combo_window = COMBO_FOLLOWUP_WINDOW
	else:
		_attack_timer = HEAVY_RECOVERY
		_combo_lights = 0
		_combo_window = 0.0


func _set_hitbox_active(on: bool) -> void:
	if _hitbox:
		_hitbox.set_active(on)
	if _hit_visual:
		_hit_visual.visible = on
		if on:
			_hit_visual.color = (
				Color(0.85, 0.85, 0.9, 0.7)
				if attack_kind == AttackKind.LIGHT
				else Color(0.95, 0.75, 0.2, 0.8)
			)


func _apply_hitbox_shape() -> void:
	if _hitbox == null:
		return
	var size := LIGHT_HITBOX_SIZE if attack_kind == AttackKind.LIGHT else HEAVY_HITBOX_SIZE
	if attack_kind == AttackKind.NONE:
		size = LIGHT_HITBOX_SIZE
	var dir := -1 if facing < 0 else 1
	_hitbox.position = Vector2(float(dir) * (BODY_HALF_WIDTH + size.x * 0.5), 0.0)
	if _hit_shape and _hit_shape.shape is RectangleShape2D:
		(_hit_shape.shape as RectangleShape2D).size = size
	if _hit_visual:
		_hit_visual.size = size
		_hit_visual.position = -size * 0.5


func _heavy_rooted() -> bool:
	return (
		attack_kind == AttackKind.HEAVY
		and (attack_phase == AttackPhase.WINDUP or attack_phase == AttackPhase.ACTIVE)
	)


func _get_move_axis() -> float:
	if move_axis_override != null:
		return float(move_axis_override)
	return Input.get_axis("move_left", "move_right")


func _gravity() -> float:
	return float(ProjectSettings.get_setting("physics/2d/default_gravity"))


func _try_consume_jump() -> void:
	if _jump_buffer_timer <= 0.0:
		return
	if _dodging or is_dead or _heavy_rooted():
		return
	var can_jump := is_on_floor() or _coyote_timer > 0.0
	if not can_jump:
		return
	velocity.y = JUMP_VELOCITY
	_jump_buffer_timer = 0.0
	_coyote_timer = 0.0
	_jumped_this_frame = true


func _physics_process(delta: float) -> void:
	_jumped_this_frame = false

	if not is_dead:
		if Input.is_action_just_pressed("jump"):
			request_jump()
		if Input.is_action_just_released("jump"):
			release_jump()
		if Input.is_action_just_pressed("dodge"):
			request_dodge()
		if Input.is_action_just_pressed("attack_light"):
			request_attack_light()
		if Input.is_action_just_pressed("attack_heavy"):
			request_attack_heavy()
		if Input.is_action_just_pressed("throw"):
			request_throw()

	if _iframe_timer > 0.0:
		_iframe_timer = maxf(_iframe_timer - delta, 0.0)
		if _iframe_timer <= 0.0:
			invulnerable = false

	_hurt_flash_timer = maxf(_hurt_flash_timer - delta, 0.0)
	if _combo_window > 0.0:
		_combo_window = maxf(_combo_window - delta, 0.0)
		if _combo_window <= 0.0 and attack_phase == AttackPhase.IDLE:
			_combo_lights = 0

	_tick_attack(delta)

	if is_dead:
		velocity = Vector2.ZERO
		move_and_slide()
		_update_animation()
		_update_iframe_visual()
		return

	if _dodging:
		_dodge_timer -= delta
		velocity.y += _gravity() * DODGE_GRAVITY_SCALE * delta
		velocity.x = float(facing) * DODGE_SPEED
		if _dodge_timer <= 0.0:
			_dodging = false
			_dodge_cooldown_timer = DODGE_COOLDOWN
	else:
		_dodge_cooldown_timer = maxf(_dodge_cooldown_timer - delta, 0.0)
		if not is_on_floor():
			velocity.y += _gravity() * delta
		var axis := _get_move_axis()
		if not _heavy_rooted() and absf(axis) > 0.01:
			facing = 1 if axis > 0.0 else -1
		if _heavy_rooted():
			velocity.x = 0.0
		elif attack_kind == AttackKind.LIGHT and attack_phase != AttackPhase.IDLE:
			velocity.x = axis * SPEED * LIGHT_MOVE_SCALE
		else:
			velocity.x = axis * SPEED

	_try_consume_jump()
	_jump_buffer_timer = maxf(_jump_buffer_timer - delta, 0.0)
	_apply_hitbox_shape()

	move_and_slide()

	if _jumped_this_frame:
		_coyote_timer = 0.0
	elif is_on_floor():
		_coyote_timer = COYOTE_TIME
	else:
		_coyote_timer = maxf(_coyote_timer - delta, 0.0)

	_update_animation()
	_update_iframe_visual()


func _tick_attack(delta: float) -> void:
	if attack_phase == AttackPhase.IDLE:
		return
	_attack_timer -= delta
	if _attack_timer > 0.0:
		return
	match attack_phase:
		AttackPhase.WINDUP:
			_enter_attack_active()
		AttackPhase.ACTIVE:
			_enter_attack_recovery()
		AttackPhase.RECOVERY:
			attack_kind = AttackKind.NONE
			attack_phase = AttackPhase.IDLE
			_set_hitbox_active(false)


func _on_died() -> void:
	if is_dead:
		return
	is_dead = true
	_cancel_attack()
	invulnerable = true
	velocity = Vector2.ZERO
	if _reload_started:
		return
	_reload_started = true
	var tree := get_tree()
	if tree == null:
		return
	tree.create_timer(DEATH_RELOAD_DELAY).timeout.connect(_reload_if_playing, CONNECT_ONE_SHOT)


func _reload_if_playing() -> void:
	if DisplayServer.get_name() == "headless":
		return
	var tree := get_tree()
	if tree == null or tree.current_scene == null:
		return
	tree.reload_current_scene()


func _on_damaged(_amount: int, remaining: int) -> void:
	_update_hp_label(remaining)
	if not invulnerable:
		_hurt_flash_timer = Health.HURT_FLASH_DURATION


func _update_hp_label(value: int) -> void:
	if _hp_label:
		_hp_label.text = str(value)


func _update_ammo_label() -> void:
	if _ammo_label:
		_ammo_label.text = str(shuriken_ammo)


func _update_animation() -> void:
	if _sprite == null:
		return
	_sprite.flip_h = facing < 0
	var anim := "idle"
	if _dodging:
		anim = "dodge"
	elif not is_on_floor():
		anim = "jump" if velocity.y < 0.0 else "fall"
	elif absf(velocity.x) > 10.0:
		anim = "run"
	if _sprite.animation != anim:
		_sprite.play(anim)


func _update_iframe_visual() -> void:
	if invulnerable:
		var pulse := 0.4 + 0.6 * absf(sin(float(Time.get_ticks_msec()) * 0.035))
		modulate = Color(1.0, 0.45, 0.45, pulse)
	elif _hurt_flash_timer > 0.0:
		modulate = Color(1.5, 0.4, 0.4, 1.0)
	else:
		modulate = Color.WHITE
