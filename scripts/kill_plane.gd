class_name KillPlane
extends Area2D

signal player_fell


func _ready() -> void:
	add_to_group("kill_plane")
	monitoring = true
	monitorable = false
	collision_layer = 0
	collision_mask = 2
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return
	player_fell.emit()
	var health: Health = body.get_node_or_null("Health") as Health
	if health and health.current > 0:
		health.take_damage(health.current)
