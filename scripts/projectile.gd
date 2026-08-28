class_name Projectile
extends Area2D

const SHURIKEN_SPEED := 420.0
const SHURIKEN_LIFETIME := 1.2
const WORLD_LAYER_BIT := 1

@export var team: StringName = &"player"
@export var damage: int = 0
@export var speed: float = SHURIKEN_SPEED
@export var direction: int = 1

var velocity: Vector2 = Vector2.ZERO

var _hit_ids: Dictionary = {}
var _life: float = SHURIKEN_LIFETIME
var _spent: bool = false


func configure(p_team: StringName, p_damage: int, p_direction: int, p_speed: float = SHURIKEN_SPEED) -> void:
	team = p_team
	damage = p_damage
	direction = -1 if p_direction < 0 else 1
	speed = p_speed
	velocity = Vector2(float(direction) * speed, 0.0)
	_apply_collision()
	_apply_group()
	_tint_visual()


func _ready() -> void:
	monitoring = true
	monitorable = false
	if velocity == Vector2.ZERO:
		velocity = Vector2(float(direction) * speed, 0.0)
	if damage <= 0:
		damage = Health.SHURIKEN_DAMAGE if team == &"player" else Health.THROWER_DAMAGE
	_apply_collision()
	_apply_group()
	_tint_visual()
	if not area_entered.is_connected(_on_area_entered):
		area_entered.connect(_on_area_entered)
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)


func _physics_process(delta: float) -> void:
	if _spent:
		return
	global_position += velocity * delta
	_life -= delta
	if _life <= 0.0:
		_despawn()
		return
	_strike_overlaps()
	_query_and_strike()


func _apply_collision() -> void:
	if team == &"player":
		collision_layer = 128
		collision_mask = WORLD_LAYER_BIT | 4 | 32
	else:
		collision_layer = 256
		collision_mask = WORLD_LAYER_BIT | 2


func _apply_group() -> void:
	if is_in_group("player_projectile"):
		remove_from_group("player_projectile")
	if is_in_group("enemy_projectile"):
		remove_from_group("enemy_projectile")
	add_to_group("player_projectile" if team == &"player" else "enemy_projectile")


func _tint_visual() -> void:
	var visual := get_node_or_null("Visual") as ColorRect
	if visual == null:
		return
	if team == &"player":
		visual.color = Color(0.78, 0.82, 0.9, 1)
	else:
		visual.color = Color(0.82, 0.28, 0.22, 1)


func _on_area_entered(area: Area2D) -> void:
	_try_strike(area)


func _on_body_entered(body: Node2D) -> void:
	if _spent:
		return
	if body is CollisionObject2D and ((body as CollisionObject2D).collision_layer & WORLD_LAYER_BIT) != 0:
		_despawn()


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
	if _spent:
		return
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
		_despawn()


func _despawn() -> void:
	if _spent:
		return
	_spent = true
	queue_free()
