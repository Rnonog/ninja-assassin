class_name ArenaController
extends Node

var is_locked: bool = false
var is_won: bool = false

@export var enter_path: NodePath
@export var exit_path: NodePath
@export var left_wall_path: NodePath
@export var right_wall_path: NodePath
@export var boss_path: NodePath
@export var hp_bar_path: NodePath
@export var overlay_path: NodePath

var _boss: ClanCaptain
var _overlay: OutcomeOverlay
var _hp_bar: BossHpBar
var _player: Player
var _left_wall: StaticBody2D
var _right_wall: StaticBody2D
var _bound: bool = false
var _enter_grace: int = 0


func _ready() -> void:
	add_to_group("arena")
	call_deferred("_bind")


func _bind() -> void:
	_boss = _resolve(boss_path) as ClanCaptain
	_overlay = _resolve(overlay_path) as OutcomeOverlay
	_hp_bar = _resolve(hp_bar_path) as BossHpBar
	_player = get_tree().get_first_node_in_group("player") as Player
	var resolved_left := _resolve(left_wall_path) as StaticBody2D
	if resolved_left:
		_left_wall = resolved_left
	var resolved_right := _resolve(right_wall_path) as StaticBody2D
	if resolved_right:
		_right_wall = resolved_right
	if not is_locked:
		_set_wall_closed(_left_wall, false)
		_set_wall_closed(_right_wall, false)
	var enter := _resolve(enter_path) as Area2D
	if enter and not enter.body_entered.is_connected(_on_enter):
		enter.body_entered.connect(_on_enter)
		for body in enter.get_overlapping_bodies():
			_on_enter(body)
	var exit_area := _resolve(exit_path) as Area2D
	if exit_area and not exit_area.body_entered.is_connected(_on_exit):
		exit_area.body_entered.connect(_on_exit)
		for body in exit_area.get_overlapping_bodies():
			_on_exit(body)
	if _boss and _boss.health and not _boss.health.died.is_connected(_on_boss_died):
		_boss.health.died.connect(_on_boss_died)
	if _player and _player.health and not _player.health.died.is_connected(_on_player_died):
		_player.health.died.connect(_on_player_died)
	var session := get_tree().get_first_node_in_group("run_session")
	if session and session.has_signal("respawned") and not session.respawned.is_connected(_on_respawned):
		session.respawned.connect(_on_respawned)
	if _hp_bar:
		_hp_bar.bind_boss(_boss)
		_hp_bar.set_bar_visible(is_locked and _boss != null and not _boss.is_dead)
	_bound = true


func _physics_process(_delta: float) -> void:
	if not _bound or is_locked or is_won:
		return
	if _enter_grace > 0:
		_enter_grace -= 1
		return
	var enter := _resolve(enter_path) as Area2D
	if enter == null:
		return
	for body in enter.get_overlapping_bodies():
		_on_enter(body)


func lock_arena() -> void:
	if is_locked or is_won:
		return
	if _boss == null:
		_boss = _resolve(boss_path) as ClanCaptain
	if _boss == null or _boss.is_dead:
		return
	is_locked = true
	_set_wall_closed(_left_wall, true)
	_set_wall_closed(_right_wall, true)
	_boss.auto_aggro = true
	if _hp_bar:
		_hp_bar.set_bar_visible(true)


func reset_if_boss_alive() -> void:
	if is_won:
		return
	if _boss == null or _boss.is_dead:
		return
	is_locked = false
	_enter_grace = 3
	_set_wall_closed(_left_wall, false)
	_set_wall_closed(_right_wall, false)
	_boss.restore_fight()
	if _hp_bar:
		_hp_bar.set_bar_visible(false)
	if _overlay:
		_overlay.hide_outcome()


func _on_enter(body: Node2D) -> void:
	if _enter_grace > 0:
		return
	if body.is_in_group("player"):
		lock_arena.call_deferred()


func _on_exit(body: Node2D) -> void:
	if not body.is_in_group("player"):
		return
	if _boss == null or not _boss.is_dead:
		return
	if is_won:
		return
	is_won = true
	if _overlay:
		_overlay.show_victory()
	if _player:
		_player.set_control_locked(true)


func _on_boss_died() -> void:
	_set_wall_closed(_right_wall, false)
	if _hp_bar:
		_hp_bar.set_bar_visible(false)


func _on_player_died() -> void:
	if is_won:
		return
	if _overlay:
		_overlay.show_defeat()


func _on_respawned() -> void:
	reset_if_boss_alive()


func is_left_wall_closed() -> bool:
	return _is_wall_closed(_left_wall)


func is_right_wall_closed() -> bool:
	return _is_wall_closed(_right_wall)


func _set_wall_closed(wall: StaticBody2D, closed: bool) -> void:
	if wall == null:
		return
	# Keep shapes enabled; a CollisionShape2D that entered the tree disabled
	# often never registers with the physics server when re-enabled.
	var shape := _wall_shape(wall)
	if shape and shape.disabled:
		shape.set_deferred("disabled", false)
	var layer := 1 if closed else 0
	if wall.collision_layer != layer:
		wall.set_deferred("collision_layer", layer)
	wall.visible = closed


func _is_wall_closed(wall: StaticBody2D) -> bool:
	if wall == null:
		return false
	return wall.collision_layer != 0


func _wall_shape(wall: StaticBody2D) -> CollisionShape2D:
	var named := wall.get_node_or_null("CollisionShape2D") as CollisionShape2D
	if named:
		return named
	for child in wall.get_children():
		if child is CollisionShape2D:
			return child
	return null


func _resolve(path: NodePath) -> Node:
	if path.is_empty():
		return null
	var node := get_node_or_null(path)
	if node:
		return node
	var tree := get_tree()
	if tree:
		node = tree.root.get_node_or_null(path)
		if node:
			return node
	var parent := get_parent()
	if parent == null:
		return null
	var leaf := String(path)
	if leaf.contains("/"):
		leaf = leaf.get_file()
	return parent.get_node_or_null(leaf)
