extends SceneTree

const PlayerGD := preload("res://scripts/player.gd")
const DummyGD := preload("res://scripts/dummy.gd")
const HealthGD := preload("res://scripts/health.gd")
const ClanThugGD := preload("res://scripts/clan_thug.gd")
const ThrowFighterGD := preload("res://scripts/throw_fighter.gd")

const ACTIONS := [
	"move_left",
	"move_right",
	"jump",
	"dodge",
	"attack_light",
	"attack_heavy",
	"throw",
	"pause",
]

const PLAYER_COLLISION_SIZE := Vector2(24, 40)
const FLOOR_POS := Vector2(0, 200)
const FLOOR_SIZE := Vector2(800, 40)

var _passed := 0
var _failed := 0


func _initialize() -> void:
	await _run_all()
	print("==== %d passed, %d failed ====" % [_passed, _failed])
	quit(1 if _failed > 0 else 0)


func _run_all() -> void:
	await _test_main_boot()
	_test_input_actions()
	await _test_gravity()
	await _test_jump_from_floor()
	await _test_coyote()
	await _test_no_air_jump_after_coyote()
	await _test_jump_buffer()
	await _test_variable_height()
	await _test_dodge_iframes()
	await _test_player_starts_at_max_hp()
	await _test_no_hp_regen()
	await _test_light_hits_dummy()
	await _test_heavy_hits_dummy()
	await _test_dummy_swipe_damages_player()
	await _test_second_dummy_swipe_damages_again()
	await _test_dummy_swipe_hits_adjacent_player()
	await _test_dodge_blocks_dummy_swipe()
	await _test_death_stops_move_and_attack()
	if PlayerGD.COMBO_ENABLED:
		await _test_combo_light_light_heavy()
	await _test_throw_without_ammo()
	await _test_throw_hits_dummy()
	await _test_ammo_pickup()
	await _test_heal_pickup()
	await _test_thug_chase_and_stab()
	await _test_dodge_blocks_thug_stab()
	await _test_thrower_projectile_hits_player()
	await _test_dodge_blocks_thrower_projectile()
	await _test_shuriken_interrupts_thrower_telegraph()
	await _test_enemies_die_at_zero_hp()
	_test_player_scene_art()
	await _test_level_art()
	_test_platforms_within_jump()


func _check(test_name: String, ok: bool, detail: String = "") -> void:
	if ok:
		_passed += 1
		print("PASS: %s" % test_name)
	else:
		_failed += 1
		if detail.is_empty():
			print("FAIL: %s" % test_name)
		else:
			print("FAIL: %s — %s" % [test_name, detail])


func _step_physics(frames: int) -> void:
	for _i in frames:
		await physics_frame


func _make_player_collision() -> CollisionShape2D:
	var node := CollisionShape2D.new()
	var rect := RectangleShape2D.new()
	rect.size = PLAYER_COLLISION_SIZE
	node.shape = rect
	return node


func _spawn_floor(world: Node, pos: Vector2, size: Vector2) -> StaticBody2D:
	var floor_body := StaticBody2D.new()
	floor_body.position = pos
	var shape_node := CollisionShape2D.new()
	var rect := RectangleShape2D.new()
	rect.size = size
	shape_node.shape = rect
	floor_body.add_child(shape_node)
	world.add_child(floor_body)
	return floor_body


func _spawn_player(world: Node, pos: Vector2) -> CharacterBody2D:
	var player: CharacterBody2D = PlayerGD.new()
	player.add_child(_make_player_collision())
	player.position = pos
	player.set_move_axis(0.0)
	world.add_child(player)
	return player


func _teardown(world: Node) -> void:
	if is_instance_valid(world):
		world.free()


func _wait_on_floor(player: CharacterBody2D, max_frames: int = 90) -> bool:
	for _i in max_frames:
		if player.is_on_floor():
			return true
		await physics_frame
	return player.is_on_floor()


func _test_main_boot() -> void:
	var packed: PackedScene = load("res://scenes/main.tscn")
	if packed == null:
		_check("main_boot", false, "failed to load res://scenes/main.tscn")
		return
	var main := packed.instantiate()
	root.add_child(main)
	await _step_physics(2)
	_check("main_boot", is_instance_valid(main), "main scene invalid after boot")
	_teardown(main)


func _test_input_actions() -> void:
	var missing: PackedStringArray = []
	for action in ACTIONS:
		if not InputMap.has_action(action):
			missing.append(action)
	_check("input_actions", missing.is_empty(), "missing: %s" % ",".join(missing))


func _test_gravity() -> void:
	var world := Node2D.new()
	root.add_child(world)
	var player := _spawn_player(world, Vector2(0, 0))
	await _step_physics(2)
	var start_y := player.position.y
	var start_vy := player.velocity.y
	await _step_physics(10)
	var fell := player.velocity.y > start_vy and player.position.y > start_y
	_check(
		"gravity",
		fell,
		"vy %s -> %s, y %s -> %s" % [start_vy, player.velocity.y, start_y, player.position.y]
	)
	_teardown(world)


func _test_jump_from_floor() -> void:
	var world := Node2D.new()
	root.add_child(world)
	_spawn_floor(world, FLOOR_POS, FLOOR_SIZE)
	var player := _spawn_player(world, Vector2(0, 158))
	var on_floor := await _wait_on_floor(player)
	if not on_floor:
		_check("jump_from_floor", false, "never landed")
		_teardown(world)
		return
	player.request_jump()
	await physics_frame
	_check(
		"jump_from_floor",
		player.velocity.y < 0.0,
		"velocity.y=%s" % player.velocity.y
	)
	_teardown(world)


func _test_coyote() -> void:
	var world := Node2D.new()
	root.add_child(world)
	_spawn_floor(world, FLOOR_POS, FLOOR_SIZE)
	var player := _spawn_player(world, Vector2(0, 158))
	var on_floor := await _wait_on_floor(player)
	if not on_floor:
		_check("coyote", false, "never landed")
		_teardown(world)
		return
	player.position.y -= 30.0
	await _step_physics(2)
	if player.is_on_floor():
		_check("coyote", false, "still on floor after leaving")
		_teardown(world)
		return
	player.request_jump()
	await physics_frame
	_check("coyote", player.velocity.y < 0.0, "velocity.y=%s" % player.velocity.y)
	_teardown(world)


func _test_no_air_jump_after_coyote() -> void:
	var world := Node2D.new()
	root.add_child(world)
	_spawn_floor(world, FLOOR_POS, FLOOR_SIZE)
	var player := _spawn_player(world, Vector2(0, 158))
	var on_floor := await _wait_on_floor(player)
	if not on_floor:
		_check("no_air_jump_after_coyote", false, "never landed")
		_teardown(world)
		return
	player.position.y -= 30.0
	await _step_physics(2)
	if player.is_on_floor():
		_check("no_air_jump_after_coyote", false, "still on floor after leaving")
		_teardown(world)
		return
	var ticks := Engine.physics_ticks_per_second
	var wait_frames := int(ceil(PlayerGD.COYOTE_TIME * float(ticks))) + 1
	await _step_physics(wait_frames)
	var vy_before := player.velocity.y
	player.request_jump()
	await physics_frame
	_check(
		"no_air_jump_after_coyote",
		player.velocity.y >= 0.0 and player.velocity.y >= vy_before,
		"air jump after coyote: vy_before=%s vy=%s" % [vy_before, player.velocity.y]
	)
	_teardown(world)


func _floor_top() -> float:
	return FLOOR_POS.y - FLOOR_SIZE.y * 0.5


func _player_half_height() -> float:
	return PLAYER_COLLISION_SIZE.y * 0.5


func _test_jump_buffer() -> void:
	var world := Node2D.new()
	root.add_child(world)
	_spawn_floor(world, FLOOR_POS, FLOOR_SIZE)
	var player := _spawn_player(world, Vector2(0, 40))
	await _step_physics(2)
	var gravity := float(ProjectSettings.get_setting("physics/2d/default_gravity"))
	var buffer := PlayerGD.JUMP_BUFFER
	var buffered := false
	for _i in 120:
		if player.is_on_floor():
			break
		var dist_to_floor := _floor_top() - (player.position.y + _player_half_height())
		var reach := player.velocity.y * buffer + 0.5 * gravity * buffer * buffer
		if not buffered and dist_to_floor > 0.0 and reach >= dist_to_floor:
			player.request_jump()
			buffered = true
		await physics_frame
	if not buffered:
		_check("jump_buffer", false, "never got close enough to buffer a jump")
		_teardown(world)
		return
	var saw_jump := false
	var landed := false
	for _i in 30:
		await physics_frame
		if player.is_on_floor():
			landed = true
		if player.velocity.y < 0.0:
			saw_jump = true
			break
	_check("jump_buffer", saw_jump, "buffered=%s landed=%s vy=%s y=%s" % [buffered, landed, player.velocity.y, player.position.y])
	_teardown(world)


func _test_variable_height() -> void:
	var world := Node2D.new()
	root.add_child(world)
	_spawn_floor(world, FLOOR_POS, FLOOR_SIZE)
	var player := _spawn_player(world, Vector2(0, 158))
	var frames := 8

	var on_floor := await _wait_on_floor(player)
	if not on_floor:
		_check("variable_height", false, "never landed before held jump")
		_teardown(world)
		return
	player.request_jump()
	await _step_physics(frames)
	var held_vy := player.velocity.y

	player.velocity = Vector2.ZERO
	player.position = Vector2(0, 158)
	on_floor = await _wait_on_floor(player)
	if not on_floor:
		_check("variable_height", false, "never landed before tap jump")
		_teardown(world)
		return
	player.request_jump()
	await physics_frame
	player.release_jump()
	await _step_physics(frames - 1)
	var cut_vy := player.velocity.y
	_check(
		"variable_height",
		cut_vy > held_vy,
		"held_vy=%s cut_vy=%s" % [held_vy, cut_vy]
	)
	_teardown(world)


func _test_dodge_iframes() -> void:
	var world := Node2D.new()
	root.add_child(world)
	var player := _spawn_player(world, Vector2(0, 0))
	await physics_frame
	player.request_dodge()
	if not player.invulnerable:
		_check("dodge_iframes", false, "invulnerable was false after request_dodge")
		_teardown(world)
		return
	var ticks := Engine.physics_ticks_per_second
	var wait_frames := int(ceil(PlayerGD.IFRAME_DURATION * float(ticks))) + 3
	await _step_physics(wait_frames)
	_check("dodge_iframes", not player.invulnerable, "still invulnerable after i-frames")
	_teardown(world)


func _frames_for(seconds: float) -> int:
	return int(ceil(seconds * float(Engine.physics_ticks_per_second))) + 2


func _spawn_combat_player(world: Node, pos: Vector2):
	var packed: PackedScene = load("res://scenes/player.tscn")
	var player = packed.instantiate()
	player.position = pos
	player.set_move_axis(0.0)
	world.add_child(player)
	return player


func _spawn_combat_dummy(world: Node, pos: Vector2):
	var packed: PackedScene = load("res://scenes/dummy.tscn")
	var dummy = packed.instantiate()
	dummy.auto_loop = false
	dummy.position = pos
	world.add_child(dummy)
	return dummy


func _test_player_starts_at_max_hp() -> void:
	var world := Node2D.new()
	root.add_child(world)
	var player = _spawn_combat_player(world, Vector2(0, 0))
	await physics_frame
	_check(
		"player_starts_at_max_hp",
		player.health != null and player.health.current == HealthGD.MAX_HP,
		"hp=%s" % (player.health.current if player.health else -1)
	)
	_teardown(world)


func _test_no_hp_regen() -> void:
	var world := Node2D.new()
	root.add_child(world)
	var player = _spawn_combat_player(world, Vector2(0, 0))
	await physics_frame
	player.health.take_damage(HealthGD.LIGHT_DAMAGE)
	var after_hit: int = player.health.current
	await _step_physics(20)
	_check(
		"no_hp_regen",
		player.health.current == after_hit,
		"hp %s -> %s" % [after_hit, player.health.current]
	)
	_teardown(world)


func _test_light_hits_dummy() -> void:
	var world := Node2D.new()
	root.add_child(world)
	_spawn_floor(world, FLOOR_POS, FLOOR_SIZE)
	var player = _spawn_combat_player(world, Vector2(0, 158))
	var dummy = _spawn_combat_dummy(world, Vector2(36, 158))
	await _step_physics(3)
	var start_hp: int = dummy.health.current
	player.facing = 1
	player.request_attack_light()
	await _step_physics(_frames_for(PlayerGD.LIGHT_WINDUP + PlayerGD.LIGHT_ACTIVE))
	_check(
		"light_hits_dummy",
		dummy.health.current == start_hp - HealthGD.LIGHT_DAMAGE,
		"hp %s -> %s (expected %s)" % [start_hp, dummy.health.current, start_hp - HealthGD.LIGHT_DAMAGE]
	)
	_teardown(world)


func _test_heavy_hits_dummy() -> void:
	var world := Node2D.new()
	root.add_child(world)
	_spawn_floor(world, FLOOR_POS, FLOOR_SIZE)
	var player = _spawn_combat_player(world, Vector2(0, 158))
	var dummy = _spawn_combat_dummy(world, Vector2(36, 158))
	await _step_physics(3)
	var start_hp: int = dummy.health.current
	player.facing = 1
	player.request_attack_heavy()
	await _step_physics(_frames_for(PlayerGD.HEAVY_WINDUP + PlayerGD.HEAVY_ACTIVE))
	var dropped: int = start_hp - dummy.health.current
	_check(
		"heavy_hits_dummy",
		dropped == HealthGD.HEAVY_DAMAGE and HealthGD.HEAVY_DAMAGE != HealthGD.LIGHT_DAMAGE,
		"hp %s -> %s dropped=%s" % [start_hp, dummy.health.current, dropped]
	)
	_teardown(world)


func _test_dummy_swipe_damages_player() -> void:
	var world := Node2D.new()
	root.add_child(world)
	_spawn_floor(world, FLOOR_POS, FLOOR_SIZE)
	var player = _spawn_combat_player(world, Vector2(0, 158))
	var dummy = _spawn_combat_dummy(world, Vector2(40, 158))
	await _step_physics(3)
	var start_hp: int = player.health.current
	dummy.request_swipe()
	await _step_physics(_frames_for(DummyGD.DUMMY_TELEGRAPH + DummyGD.DUMMY_ACTIVE))
	_check(
		"dummy_swipe_damages_player",
		player.health.current == start_hp - HealthGD.DUMMY_DAMAGE,
		"hp %s -> %s" % [start_hp, player.health.current]
	)
	_teardown(world)


func _test_second_dummy_swipe_damages_again() -> void:
	var world := Node2D.new()
	root.add_child(world)
	_spawn_floor(world, FLOOR_POS, FLOOR_SIZE)
	var player = _spawn_combat_player(world, Vector2(0, 158))
	var dummy = _spawn_combat_dummy(world, Vector2(40, 158))
	await _step_physics(3)
	dummy.request_swipe()
	await _step_physics(_frames_for(DummyGD.DUMMY_TELEGRAPH + DummyGD.DUMMY_ACTIVE))
	var after_first: int = player.health.current
	if after_first != HealthGD.MAX_HP - HealthGD.DUMMY_DAMAGE:
		_check(
			"second_dummy_swipe_damages_again",
			false,
			"first swipe did not land hp=%s" % after_first
		)
		_teardown(world)
		return
	dummy.request_swipe()
	await _step_physics(_frames_for(DummyGD.DUMMY_TELEGRAPH + DummyGD.DUMMY_ACTIVE))
	_check(
		"second_dummy_swipe_damages_again",
		player.health.current == after_first - HealthGD.DUMMY_DAMAGE,
		"hp after first=%s after second=%s" % [after_first, player.health.current]
	)
	_teardown(world)


func _test_dummy_swipe_hits_adjacent_player() -> void:
	var world := Node2D.new()
	root.add_child(world)
	_spawn_floor(world, FLOOR_POS, FLOOR_SIZE)
	var dummy = _spawn_combat_dummy(world, Vector2(40, 158))
	var player = _spawn_combat_player(world, Vector2(40, 158))
	await _step_physics(3)
	var start_hp: int = player.health.current
	dummy.request_swipe()
	await _step_physics(_frames_for(DummyGD.DUMMY_TELEGRAPH + DummyGD.DUMMY_ACTIVE))
	_check(
		"dummy_swipe_hits_adjacent_player",
		player.health.current == start_hp - HealthGD.DUMMY_DAMAGE,
		"standing on dummy hp %s -> %s" % [start_hp, player.health.current]
	)
	_teardown(world)


func _test_dodge_blocks_dummy_swipe() -> void:
	var world := Node2D.new()
	root.add_child(world)
	_spawn_floor(world, FLOOR_POS, FLOOR_SIZE)
	var player = _spawn_combat_player(world, Vector2(0, 158))
	var dummy = _spawn_combat_dummy(world, Vector2(40, 158))
	await _step_physics(3)
	var start_hp: int = player.health.current
	dummy.request_swipe()
	var telegraph_frames := maxi(int(floor(DummyGD.DUMMY_TELEGRAPH * float(Engine.physics_ticks_per_second))) - 1, 1)
	await _step_physics(telegraph_frames)
	player.request_dodge()
	await _step_physics(_frames_for(DummyGD.DUMMY_ACTIVE + 0.05))
	_check(
		"dodge_blocks_dummy_swipe",
		player.health.current == start_hp,
		"hp %s -> %s invulnerable=%s" % [start_hp, player.health.current, player.invulnerable]
	)
	_teardown(world)


func _test_death_stops_move_and_attack() -> void:
	var world := Node2D.new()
	root.add_child(world)
	var player = _spawn_combat_player(world, Vector2(0, 0))
	await physics_frame
	player.health.take_damage(HealthGD.MAX_HP)
	await physics_frame
	if not player.is_dead:
		_check("death_stops_move_and_attack", false, "is_dead was false after MAX_HP damage")
		_teardown(world)
		return
	player.set_move_axis(1.0)
	player.request_attack_light()
	await _step_physics(4)
	_check(
		"death_stops_move_and_attack",
		is_equal_approx(player.velocity.x, 0.0)
		and player.attack_kind == PlayerGD.AttackKind.NONE,
		"vx=%s attack=%s" % [player.velocity.x, player.attack_kind]
	)
	_teardown(world)


func _test_combo_light_light_heavy() -> void:
	var world := Node2D.new()
	root.add_child(world)
	var player = _spawn_combat_player(world, Vector2(0, 0))
	await physics_frame
	player.request_attack_light()
	await _step_physics(_frames_for(PlayerGD.LIGHT_WINDUP + PlayerGD.LIGHT_ACTIVE))
	if player.attack_phase != PlayerGD.AttackPhase.RECOVERY:
		_check("combo_light_light_heavy", false, "not in recovery after first light")
		_teardown(world)
		return
	player.request_attack_light()
	if player.attack_kind != PlayerGD.AttackKind.LIGHT or player.attack_phase == PlayerGD.AttackPhase.RECOVERY:
		_check(
			"combo_light_light_heavy",
			false,
			"second light did not cancel recovery kind=%s phase=%s" % [player.attack_kind, player.attack_phase]
		)
		_teardown(world)
		return
	await _step_physics(_frames_for(PlayerGD.LIGHT_WINDUP + PlayerGD.LIGHT_ACTIVE))
	player.request_attack_heavy()
	_check(
		"combo_light_light_heavy",
		player.attack_kind == PlayerGD.AttackKind.HEAVY,
		"kind=%s phase=%s" % [player.attack_kind, player.attack_phase]
	)
	_teardown(world)


func _test_player_scene_art() -> void:
	var packed: PackedScene = load("res://scenes/player.tscn")
	if packed == null:
		_check("player_scene_art", false, "failed to load res://scenes/player.tscn")
		return
	var player := packed.instantiate()
	var col := player.get_node_or_null("CollisionShape2D") as CollisionShape2D
	if col == null or col.shape == null or not (col.shape is RectangleShape2D):
		_check("player_collision_size", false, "missing RectangleShape2D")
		player.free()
		return
	var size: Vector2 = (col.shape as RectangleShape2D).size
	_check(
		"player_collision_size",
		absf(size.x - 32.0) <= 4.0 and absf(size.y - 64.0) <= 4.0,
		"size=%s" % size
	)
	var sprite := player.get_node_or_null("AnimatedSprite2D") as AnimatedSprite2D
	if sprite == null or sprite.sprite_frames == null:
		_check("player_sprite_frames", false, "missing AnimatedSprite2D or SpriteFrames")
		player.free()
		return
	var frames: SpriteFrames = sprite.sprite_frames
	var expected := {
		"idle": Vector2i(4, 6),
		"run": Vector2i(6, 8),
		"jump": Vector2i(2, 3),
		"fall": Vector2i(2, 2),
		"dodge": Vector2i(4, 6),
	}
	var missing: PackedStringArray = []
	var bad_counts: PackedStringArray = []
	for anim_name in expected:
		if not frames.has_animation(anim_name):
			missing.append(anim_name)
			continue
		var count := frames.get_frame_count(anim_name)
		var lo: int = expected[anim_name].x
		var hi: int = expected[anim_name].y
		if count < lo or count > hi:
			bad_counts.append("%s=%d" % [anim_name, count])
	_check("player_animation_names", missing.is_empty(), "missing: %s" % ",".join(missing))
	_check("player_animation_frame_counts", bad_counts.is_empty(), ",".join(bad_counts))
	player.free()


func _collect_class(node: Node, class_nm: String, out: Array) -> void:
	if node.get_class() == class_nm:
		out.append(node)
	for child in node.get_children():
		_collect_class(child, class_nm, out)


func _test_level_art() -> void:
	var packed: PackedScene = load("res://scenes/level_greybox.tscn")
	if packed == null:
		_check("level_art", false, "failed to load res://scenes/level_greybox.tscn")
		return
	var level := packed.instantiate()
	root.add_child(level)
	await physics_frame
	var tiles := level.get_node_or_null("Tiles")
	_check("level_tilemap", tiles is TileMapLayer, "Tiles node is %s" % tiles)
	if tiles is TileMapLayer:
		var tile_map := tiles as TileMapLayer
		var size := Vector2i.ZERO
		if tile_map.tile_set != null:
			size = tile_map.tile_set.tile_size
		_check("level_tile_size", size == Vector2i(32, 32), "tile_size=%s" % size)
		_check(
			"level_floor_tiles",
			tile_map.get_cell_source_id(Vector2i(-7, 12)) != -1,
			"missing floor cell at (-7, 12)"
		)
	var parallax := level.get_node_or_null("ParallaxBackground")
	_check("level_parallax", parallax is ParallaxBackground, "missing ParallaxBackground")
	var color_rects: Array = []
	_collect_class(level, "ColorRect", color_rects)
	_check("level_no_colorrect_visuals", color_rects.is_empty(), "ColorRects: %d" % color_rects.size())
	_teardown(level)


func _test_platforms_within_jump() -> void:
	var gravity := float(ProjectSettings.get_setting("physics/2d/default_gravity"))
	var jump_h := (PlayerGD.JUMP_VELOCITY * PlayerGD.JUMP_VELOCITY) / (2.0 * gravity)
	var packed: PackedScene = load("res://scenes/level_greybox.tscn")
	if packed == null:
		_check("platforms_within_jump", false, "failed to load level")
		return
	var level := packed.instantiate()
	var floor_body := level.get_node("Floor") as StaticBody2D
	var floor_shape := floor_body.get_node("CollisionShape2D").shape as RectangleShape2D
	var floor_top := floor_body.position.y - floor_shape.size.y * 0.5
	var apex_feet := floor_top - jump_h
	for plat_name in ["Platform1", "Platform2", "Platform3"]:
		var plat := level.get_node(plat_name) as StaticBody2D
		var shape := plat.get_node("CollisionShape2D").shape as RectangleShape2D
		var top := plat.position.y - shape.size.y * 0.5
		_check(
			"reach_%s" % plat_name.to_lower(),
			top >= apex_feet - 8.0,
			"top=%s apex_feet=%s" % [top, apex_feet]
		)
	level.free()


func _count_group(group_name: StringName) -> int:
	return get_nodes_in_group(group_name).size()


func _spawn_combat_thug(world: Node, pos: Vector2):
	var packed: PackedScene = load("res://scenes/clan_thug.tscn")
	var thug = packed.instantiate()
	thug.auto_aggro = false
	thug.position = pos
	world.add_child(thug)
	return thug


func _spawn_combat_thrower(world: Node, pos: Vector2):
	var packed: PackedScene = load("res://scenes/throw_fighter.tscn")
	var thrower = packed.instantiate()
	thrower.auto_aggro = false
	thrower.position = pos
	world.add_child(thrower)
	return thrower


func _spawn_pickup_scene(world: Node, pos: Vector2, scene_path: String):
	var packed: PackedScene = load(scene_path)
	var pickup = packed.instantiate()
	pickup.position = pos
	world.add_child(pickup)
	return pickup


func _test_throw_without_ammo() -> void:
	var world := Node2D.new()
	root.add_child(world)
	var player = _spawn_combat_player(world, Vector2(0, 0))
	await physics_frame
	player.shuriken_ammo = 0
	player.request_throw()
	await _step_physics(4)
	_check(
		"throw_without_ammo",
		player.shuriken_ammo == 0 and _count_group(&"player_projectile") == 0,
		"ammo=%s projectiles=%s" % [player.shuriken_ammo, _count_group(&"player_projectile")]
	)
	_teardown(world)


func _test_throw_hits_dummy() -> void:
	var world := Node2D.new()
	root.add_child(world)
	_spawn_floor(world, FLOOR_POS, FLOOR_SIZE)
	var player = _spawn_combat_player(world, Vector2(0, 158))
	var dummy = _spawn_combat_dummy(world, Vector2(36, 158))
	await _step_physics(3)
	var start_hp: int = dummy.health.current
	var start_ammo: int = player.shuriken_ammo
	player.facing = 1
	player.request_throw()
	await _step_physics(_frames_for(0.2))
	_check(
		"throw_hits_dummy",
		player.shuriken_ammo == start_ammo - 1
		and dummy.health.current == start_hp - HealthGD.SHURIKEN_DAMAGE
		and HealthGD.SHURIKEN_DAMAGE < HealthGD.LIGHT_DAMAGE,
		"ammo %s -> %s hp %s -> %s" % [start_ammo, player.shuriken_ammo, start_hp, dummy.health.current]
	)
	_teardown(world)


func _test_ammo_pickup() -> void:
	var world := Node2D.new()
	root.add_child(world)
	var player = _spawn_combat_player(world, Vector2(0, 0))
	await physics_frame
	var start_ammo: int = player.shuriken_ammo
	_spawn_pickup_scene(world, player.position, "res://scenes/ammo_pickup.tscn")
	await _step_physics(6)
	var after_pickup: int = player.shuriken_ammo
	player.shuriken_ammo = HealthGD.MAX_AMMO
	_spawn_pickup_scene(world, player.position, "res://scenes/ammo_pickup.tscn")
	await _step_physics(6)
	_check(
		"ammo_pickup",
		after_pickup == start_ammo + HealthGD.AMMO_PICKUP
		and player.shuriken_ammo == HealthGD.MAX_AMMO,
		"start=%s after=%s capped=%s" % [start_ammo, after_pickup, player.shuriken_ammo]
	)
	_teardown(world)


func _test_heal_pickup() -> void:
	var world := Node2D.new()
	root.add_child(world)
	var player = _spawn_combat_player(world, Vector2(0, 0))
	await physics_frame
	player.health.take_damage(HealthGD.HEAL_PICKUP)
	var wounded: int = player.health.current
	_spawn_pickup_scene(world, player.position, "res://scenes/heal_pickup.tscn")
	await _step_physics(6)
	var after_heal: int = player.health.current
	player.heal(HealthGD.HEAL_PICKUP)
	var at_cap: int = player.health.current
	await _step_physics(20)
	_check(
		"heal_pickup",
		wounded == HealthGD.MAX_HP - HealthGD.HEAL_PICKUP
		and after_heal == HealthGD.MAX_HP
		and at_cap == HealthGD.MAX_HP
		and player.health.current == HealthGD.MAX_HP,
		"wounded=%s after=%s cap=%s later=%s" % [wounded, after_heal, at_cap, player.health.current]
	)
	_teardown(world)


func _test_thug_chase_and_stab() -> void:
	var world := Node2D.new()
	root.add_child(world)
	_spawn_floor(world, FLOOR_POS, FLOOR_SIZE)
	var player = _spawn_combat_player(world, Vector2(0, 158))
	var thug = _spawn_combat_thug(world, Vector2(80, 158))
	thug.auto_aggro = true
	await _wait_on_floor(player)
	await _wait_on_floor(thug)
	var start_x: float = thug.position.x
	var start_hp: int = player.health.current
	await _step_physics(20)
	var moved: bool = thug.position.x < start_x
	await _step_physics(_frames_for(ClanThugGD.THUG_TELEGRAPH + ClanThugGD.THUG_ACTIVE + 0.5))
	_check(
		"thug_chase_and_stab",
		moved and player.health.current == start_hp - HealthGD.THUG_DAMAGE,
		"moved=%s x %s -> %s hp %s -> %s" % [moved, start_x, thug.position.x, start_hp, player.health.current]
	)
	_teardown(world)


func _test_dodge_blocks_thug_stab() -> void:
	var world := Node2D.new()
	root.add_child(world)
	_spawn_floor(world, FLOOR_POS, FLOOR_SIZE)
	var player = _spawn_combat_player(world, Vector2(0, 158))
	var thug = _spawn_combat_thug(world, Vector2(40, 158))
	await _step_physics(3)
	var start_hp: int = player.health.current
	thug.request_stab()
	var telegraph_frames := maxi(
		int(floor(ClanThugGD.THUG_TELEGRAPH * float(Engine.physics_ticks_per_second))) - 1, 1
	)
	await _step_physics(telegraph_frames)
	player.request_dodge()
	await _step_physics(_frames_for(ClanThugGD.THUG_ACTIVE + 0.05))
	_check(
		"dodge_blocks_thug_stab",
		player.health.current == start_hp,
		"hp %s -> %s invulnerable=%s" % [start_hp, player.health.current, player.invulnerable]
	)
	_teardown(world)


func _test_thrower_projectile_hits_player() -> void:
	var world := Node2D.new()
	root.add_child(world)
	_spawn_floor(world, FLOOR_POS, FLOOR_SIZE)
	var player = _spawn_combat_player(world, Vector2(0, 158))
	var thrower = _spawn_combat_thrower(world, Vector2(48, 158))
	await _step_physics(3)
	var start_hp: int = player.health.current
	thrower.request_throw_attack()
	await _step_physics(_frames_for(ThrowFighterGD.THROWER_TELEGRAPH + 0.25))
	_check(
		"thrower_projectile_hits_player",
		player.health.current == start_hp - HealthGD.THROWER_DAMAGE,
		"hp %s -> %s projectiles=%s" % [start_hp, player.health.current, _count_group(&"enemy_projectile")]
	)
	_teardown(world)


func _test_dodge_blocks_thrower_projectile() -> void:
	var world := Node2D.new()
	root.add_child(world)
	_spawn_floor(world, FLOOR_POS, FLOOR_SIZE)
	var player = _spawn_combat_player(world, Vector2(0, 158))
	var thrower = _spawn_combat_thrower(world, Vector2(48, 158))
	await _step_physics(3)
	var start_hp: int = player.health.current
	thrower.request_throw_attack()
	var telegraph_frames := maxi(
		int(floor(ThrowFighterGD.THROWER_TELEGRAPH * float(Engine.physics_ticks_per_second))) - 1, 1
	)
	await _step_physics(telegraph_frames)
	player.request_dodge()
	await _step_physics(_frames_for(0.25))
	_check(
		"dodge_blocks_thrower_projectile",
		player.health.current == start_hp,
		"hp %s -> %s invulnerable=%s" % [start_hp, player.health.current, player.invulnerable]
	)
	_teardown(world)


func _test_shuriken_interrupts_thrower_telegraph() -> void:
	var world := Node2D.new()
	root.add_child(world)
	_spawn_floor(world, FLOOR_POS, FLOOR_SIZE)
	var player = _spawn_combat_player(world, Vector2(0, 158))
	var thrower = _spawn_combat_thrower(world, Vector2(40, 158))
	await _step_physics(3)
	var start_hp: int = player.health.current
	thrower.request_throw_attack()
	await _step_physics(3)
	player.facing = 1
	player.request_throw()
	await _step_physics(_frames_for(ThrowFighterGD.THROWER_TELEGRAPH + 0.25))
	_check(
		"shuriken_interrupts_thrower_telegraph",
		player.health.current == start_hp
		and _count_group(&"enemy_projectile") == 0
		and thrower.health.current == HealthGD.THROWER_MAX_HP - HealthGD.SHURIKEN_DAMAGE,
		"player_hp=%s thrower_hp=%s enemy_stars=%s phase=%s" % [
			player.health.current,
			thrower.health.current,
			_count_group(&"enemy_projectile"),
			thrower.phase,
		]
	)
	_teardown(world)


func _test_enemies_die_at_zero_hp() -> void:
	var world := Node2D.new()
	root.add_child(world)
	_spawn_floor(world, FLOOR_POS, FLOOR_SIZE)
	var player = _spawn_combat_player(world, Vector2(0, 158))
	var thug = _spawn_combat_thug(world, Vector2(40, 158))
	var thrower = _spawn_combat_thrower(world, Vector2(80, 158))
	await _step_physics(3)
	var start_hp: int = player.health.current
	thug.health.take_damage(HealthGD.THUG_MAX_HP)
	thrower.health.take_damage(HealthGD.THROWER_MAX_HP)
	await physics_frame
	if not thug.is_dead or not thrower.is_dead:
		_check(
			"enemies_die_at_zero_hp",
			false,
			"thug_dead=%s thrower_dead=%s" % [thug.is_dead, thrower.is_dead]
		)
		_teardown(world)
		return
	thug.request_stab()
	thrower.request_throw_attack()
	await _step_physics(
		_frames_for(
			maxf(ClanThugGD.THUG_TELEGRAPH + ClanThugGD.THUG_ACTIVE, ThrowFighterGD.THROWER_TELEGRAPH)
			+ 0.25
		)
	)
	_check(
		"enemies_die_at_zero_hp",
		player.health.current == start_hp and _count_group(&"enemy_projectile") == 0,
		"hp %s -> %s enemy_stars=%s" % [start_hp, player.health.current, _count_group(&"enemy_projectile")]
	)
	_teardown(world)

