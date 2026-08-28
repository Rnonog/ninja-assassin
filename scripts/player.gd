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

var invulnerable: bool = false
var facing: int = 1
var move_axis_override: Variant = null

var _coyote_timer: float = 0.0
var _jump_buffer_timer: float = 0.0
var _dodge_timer: float = 0.0
var _dodge_cooldown_timer: float = 0.0
var _iframe_timer: float = 0.0
var _dodging: bool = false
var _jumped_this_frame: bool = false


func set_move_axis(value: float) -> void:
	move_axis_override = clampf(value, -1.0, 1.0)


func request_jump() -> void:
	_jump_buffer_timer = JUMP_BUFFER


func release_jump() -> void:
	if velocity.y < 0.0:
		velocity.y *= JUMP_CUT_MULTIPLIER


func request_dodge() -> void:
	if _dodging or _dodge_cooldown_timer > 0.0:
		return
	_dodging = true
	_dodge_timer = DODGE_DURATION
	_iframe_timer = IFRAME_DURATION
	invulnerable = true
	velocity.x = float(facing) * DODGE_SPEED


func _get_move_axis() -> float:
	if move_axis_override != null:
		return float(move_axis_override)
	return Input.get_axis("move_left", "move_right")


func _gravity() -> float:
	return float(ProjectSettings.get_setting("physics/2d/default_gravity"))


func _try_consume_jump() -> void:
	if _jump_buffer_timer <= 0.0:
		return
	if _dodging:
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

	if Input.is_action_just_pressed("jump"):
		request_jump()
	if Input.is_action_just_released("jump"):
		release_jump()
	if Input.is_action_just_pressed("dodge"):
		request_dodge()

	if _iframe_timer > 0.0:
		_iframe_timer = maxf(_iframe_timer - delta, 0.0)
		if _iframe_timer <= 0.0:
			invulnerable = false

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
		if absf(axis) > 0.01:
			facing = 1 if axis > 0.0 else -1
		velocity.x = axis * SPEED

	_try_consume_jump()
	_jump_buffer_timer = maxf(_jump_buffer_timer - delta, 0.0)

	move_and_slide()

	if _jumped_this_frame:
		_coyote_timer = 0.0
	elif is_on_floor():
		_coyote_timer = COYOTE_TIME
	else:
		_coyote_timer = maxf(_coyote_timer - delta, 0.0)

	_update_iframe_visual()


func _update_iframe_visual() -> void:
	if invulnerable:
		var pulse := 0.4 + 0.6 * absf(sin(float(Time.get_ticks_msec()) * 0.035))
		modulate = Color(1.0, 0.45, 0.45, pulse)
	else:
		modulate = Color.WHITE
