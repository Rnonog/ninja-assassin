class_name Dummy
extends Node2D

enum Phase { IDLE, TELEGRAPH, ACTIVE, PAUSE }

const DUMMY_IDLE := 0.6
const DUMMY_TELEGRAPH := 0.4
const DUMMY_ACTIVE := 0.18
const DUMMY_PAUSE := 0.8
const HITBOX_SIZE := Vector2(56, 36)
const HITBOX_FORWARD := 8.0

const COLOR_IDLE := Color(0.42, 0.36, 0.28, 1)
const COLOR_TELEGRAPH := Color(0.92, 0.72, 0.12, 1)
const COLOR_SWIPE := Color(0.78, 0.14, 0.12, 1)

@export var auto_loop: bool = true
@export var facing: int = -1

var health: Health
var phase: Phase = Phase.IDLE

var _hitbox: Hitbox
var _body: ColorRect
var _hit_visual: ColorRect
var _hit_shape: CollisionShape2D
var _timer: float = 0.0
var _hurt_flash_timer: float = 0.0


func _ready() -> void:
	health = get_node_or_null("Health") as Health
	_hitbox = get_node_or_null("Hitbox") as Hitbox
	_body = get_node_or_null("Body") as ColorRect
	if _hitbox:
		_hit_visual = _hitbox.get_node_or_null("Visual") as ColorRect
		_hit_shape = _hitbox.get_node_or_null("CollisionShape2D") as CollisionShape2D
		_hitbox.team = &"dummy"
		_hitbox.damage = Health.DUMMY_DAMAGE
		_hitbox.collision_layer = 16
		_hitbox.collision_mask = 2
		_hitbox.set_active(false)
	var hurtbox := get_node_or_null("Hurtbox") as Area2D
	if hurtbox:
		hurtbox.collision_layer = 4
		hurtbox.collision_mask = 0
		hurtbox.team = &"dummy"
	if health:
		health.damaged.connect(_on_damaged)
	_enter_phase(Phase.IDLE)


func request_swipe() -> void:
	if phase == Phase.TELEGRAPH or phase == Phase.ACTIVE:
		return
	_enter_phase(Phase.TELEGRAPH)


func _face_player() -> void:
	if not is_inside_tree():
		return
	var nodes := get_tree().get_nodes_in_group("player")
	if nodes.is_empty():
		return
	var target := nodes[0] as Node2D
	if target == null:
		return
	var dx := target.global_position.x - global_position.x
	if absf(dx) > 1.0:
		facing = 1 if dx > 0.0 else -1


func _physics_process(delta: float) -> void:
	_hurt_flash_timer = maxf(_hurt_flash_timer - delta, 0.0)
	_apply_body_color()
	_sync_hitbox_transform()

	if phase == Phase.IDLE and not auto_loop:
		return

	_timer -= delta
	if _timer > 0.0:
		return
	match phase:
		Phase.IDLE:
			_enter_phase(Phase.TELEGRAPH)
		Phase.TELEGRAPH:
			_enter_phase(Phase.ACTIVE)
		Phase.ACTIVE:
			_enter_phase(Phase.PAUSE)
		Phase.PAUSE:
			_enter_phase(Phase.IDLE)


func _enter_phase(next: Phase) -> void:
	phase = next
	match next:
		Phase.IDLE:
			_timer = DUMMY_IDLE
			_set_hitbox_active(false)
		Phase.TELEGRAPH:
			_timer = DUMMY_TELEGRAPH
			_face_player()
			_set_hitbox_active(false)
		Phase.ACTIVE:
			_timer = DUMMY_ACTIVE
			_set_hitbox_active(true)
		Phase.PAUSE:
			_timer = DUMMY_PAUSE
			_set_hitbox_active(false)
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


func _on_damaged(_amount: int, _remaining: int) -> void:
	_hurt_flash_timer = Health.HURT_FLASH_DURATION


func _apply_body_color() -> void:
	if _body == null:
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
