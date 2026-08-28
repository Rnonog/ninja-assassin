class_name Pickup
extends Area2D

enum Kind { AMMO, HEAL }

@export var kind: Kind = Kind.AMMO

var _collected: bool = false


func _ready() -> void:
	monitoring = true
	monitorable = false
	collision_layer = 0
	collision_mask = 2
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	if _collected:
		return
	if not body.is_in_group("player"):
		return
	_collected = true
	if kind == Kind.AMMO and body.has_method("add_ammo"):
		body.call("add_ammo", Health.AMMO_PICKUP)
	elif kind == Kind.HEAL and body.has_method("heal"):
		body.call("heal", Health.HEAL_PICKUP)
	queue_free()
