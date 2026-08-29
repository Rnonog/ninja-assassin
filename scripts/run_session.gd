class_name RunSession
extends Node

var spawn_position: Vector2 = Vector2.ZERO
var spawn_ammo: int = Health.START_AMMO

var _player: Player
var _respawn_queued: bool = false


func _ready() -> void:
	add_to_group("run_session")
	call_deferred("_bind")


func _bind() -> void:
	_player = get_tree().get_first_node_in_group("player") as Player
	if _player:
		spawn_position = _player.global_position
		spawn_ammo = Health.START_AMMO
		if _player.health and not _player.health.died.is_connected(_on_player_died):
			_player.health.died.connect(_on_player_died)
	var shrine := get_tree().get_first_node_in_group("checkpoint")
	if shrine and shrine.has_signal("activated") and not shrine.activated.is_connected(_on_checkpoint):
		shrine.activated.connect(_on_checkpoint)
	var plane := get_tree().get_first_node_in_group("kill_plane")
	if plane and plane.has_signal("player_fell") and not plane.player_fell.is_connected(_on_kill_plane):
		plane.player_fell.connect(_on_kill_plane)


func _on_checkpoint(world_position: Vector2, ammo: int) -> void:
	spawn_position = world_position
	spawn_ammo = ammo


func _on_kill_plane() -> void:
	_queue_respawn()


func _on_player_died() -> void:
	_queue_respawn()


func _queue_respawn() -> void:
	if _respawn_queued:
		return
	_respawn_queued = true
	var tree := get_tree()
	if tree == null:
		_respawn_queued = false
		return
	tree.create_timer(Player.DEATH_RELOAD_DELAY).timeout.connect(_do_respawn, CONNECT_ONE_SHOT)


func _do_respawn() -> void:
	_respawn_queued = false
	if _player == null or not is_instance_valid(_player):
		_player = get_tree().get_first_node_in_group("player") as Player
	if _player == null:
		return
	_player.respawn(spawn_position, spawn_ammo)
