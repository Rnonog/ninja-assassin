class_name Checkpoint
extends Area2D

signal activated(world_position: Vector2, ammo: int)

var is_activated: bool = false

var _visual: ColorRect


func _ready() -> void:
	add_to_group("checkpoint")
	monitoring = true
	monitorable = false
	collision_layer = 0
	collision_mask = 2
	_visual = get_node_or_null("Visual") as ColorRect
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	if is_activated:
		return
	if not body.is_in_group("player"):
		return
	is_activated = true
	var ammo := 0
	if body.get("shuriken_ammo") != null:
		ammo = int(body.get("shuriken_ammo"))
	if _visual:
		_visual.color = Color(0.95, 0.82, 0.35, 1)
	activated.emit(global_position, ammo)
