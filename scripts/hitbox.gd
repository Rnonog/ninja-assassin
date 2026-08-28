class_name Hitbox
extends Area2D

signal landed(hurtbox: Area2D)

@export var team: StringName = &"player"
@export var damage: int = 0

var _armed: bool = false
var _hit_ids: Dictionary = {}


func _ready() -> void:
	monitorable = false
	monitoring = true
	if not area_entered.is_connected(_on_area_entered):
		area_entered.connect(_on_area_entered)


func set_active(on: bool) -> void:
	_armed = on
	if on:
		_hit_ids.clear()
		_strike_overlaps()
		_query_and_strike()
	else:
		_hit_ids.clear()


func _physics_process(_delta: float) -> void:
	if not _armed:
		return
	_strike_overlaps()
	_query_and_strike()


func _on_area_entered(area: Area2D) -> void:
	if not _armed:
		return
	_try_strike(area)


func _strike_overlaps() -> void:
	if not monitoring:
		return
	for area in get_overlapping_areas():
		_try_strike(area)


func _query_and_strike() -> void:
	if not is_inside_tree():
		return
	var world := get_world_2d()
	if world == null:
		return
	var shape_node := get_node_or_null("CollisionShape2D") as CollisionShape2D
	if shape_node == null or shape_node.shape == null:
		return
	var params := PhysicsShapeQueryParameters2D.new()
	params.shape = shape_node.shape
	params.transform = shape_node.global_transform
	params.collision_mask = collision_mask
	params.collide_with_areas = true
	params.collide_with_bodies = false
	params.exclude = [get_rid()]
	for result in world.direct_space_state.intersect_shape(params, 16):
		var collider: Variant = result.get("collider")
		if collider is Area2D:
			_try_strike(collider as Area2D)


func _try_strike(area: Area2D) -> void:
	if not area.has_method("receive_hit"):
		return
	var other_team: StringName = area.get("team") as StringName
	if other_team == team:
		return
	var id := area.get_instance_id()
	if _hit_ids.has(id):
		return
	if area.call("receive_hit", damage, team):
		_hit_ids[id] = true
		landed.emit(area)
