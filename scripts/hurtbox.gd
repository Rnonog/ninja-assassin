class_name Hurtbox
extends Area2D

@export var team: StringName = &"player"
@export var health_path: NodePath = NodePath("../Health")

var _health: Health
var _shake_camera: Camera2D
var _shake_restore := Vector2.ZERO


func _ready() -> void:
	monitoring = false
	monitorable = true
	if health_path != NodePath(""):
		_health = get_node_or_null(health_path) as Health
	if Engine.time_scale != 1.0:
		Engine.time_scale = 1.0


func receive_hit(amount: int, from_team: StringName) -> bool:
	if from_team == team:
		return false
	var host := get_parent()
	if host != null and host.get("invulnerable") == true:
		return false
	if host != null and host.get("is_dead") == true:
		return false
	if _health == null:
		return false
	var applied: int = _health.take_damage(amount)
	if applied <= 0:
		return false
	_play_hit_feedback()
	return true


func _play_hit_feedback() -> void:
	if DisplayServer.get_name() == "headless":
		return
	var tree := get_tree()
	if tree == null:
		return
	var cam := get_viewport().get_camera_2d()
	if cam == null:
		return
	_shake_camera = cam
	_shake_restore = cam.offset
	cam.offset = _shake_restore + Vector2(5.0, -3.0)
	tree.create_timer(Health.FREEZE_FRAME_DURATION, true, false, true).timeout.connect(
		_restore_camera_offset, CONNECT_ONE_SHOT
	)


func _restore_camera_offset() -> void:
	if _shake_camera != null and is_instance_valid(_shake_camera):
		_shake_camera.offset = _shake_restore
	_shake_camera = null
