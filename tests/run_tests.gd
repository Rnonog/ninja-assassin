extends SceneTree

const PlayerGD := preload("res://scripts/player.gd")
const DummyGD := preload("res://scripts/dummy.gd")
const HealthGD := preload("res://scripts/health.gd")
const ClanThugGD := preload("res://scripts/clan_thug.gd")
const ThrowFighterGD := preload("res://scripts/throw_fighter.gd")
const ClanCaptainGD := preload("res://scripts/clan_captain.gd")
const ArenaControllerGD := preload("res://scripts/arena_controller.gd")

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
	await _test_checkpoint_stores_ammo()
	await _test_death_before_checkpoint()
	await _test_kill_plane_respawn()
	await _test_dead_enemy_stays_dead()
	await _test_pickup_stays_gone()
	_test_level_layout_order()
	_test_placeholder_contrast()
	await _test_second_shrine_overrides_spawn()
	await _test_arena_lock_blocks_left()
	await _test_stomp_hits_player()
	await _test_dodge_blocks_stomp()
	await _test_exit_without_boss_dead_no_win()
	await _test_boss_dead_opens_right_wall()
	await _test_victory_on_exit_after_boss()
	await _test_death_resets_live_boss()
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


func _attach_session(world: Node) -> Node:
	var session: Node = (load("res://scripts/run_session.gd") as GDScript).new()
	world.add_child(session)
	return session


func _wait_respawn() -> void:
	await _step_physics(_frames_for(PlayerGD.DEATH_RELOAD_DELAY + 0.15))


func _test_checkpoint_stores_ammo() -> void:
	var world := Node2D.new()
	root.add_child(world)
	_spawn_floor(world, FLOOR_POS, FLOOR_SIZE)
	var player = _spawn_combat_player(world, Vector2(0, 158))
	var shrine_packed: PackedScene = load("res://scenes/checkpoint.tscn")
	var shrine = shrine_packed.instantiate()
	shrine.position = Vector2(80, 158)
	world.add_child(shrine)
	_attach_session(world)
	await _step_physics(4)
	var stored: int = HealthGD.START_AMMO + HealthGD.AMMO_PICKUP
	player.shuriken_ammo = stored
	player.position = shrine.position
	await _step_physics(6)
	if not shrine.is_activated:
		_check("checkpoint_stores_ammo", false, "shrine did not activate")
		_teardown(world)
		return
	var id_before: int = player.get_instance_id()
	player.health.take_damage(HealthGD.MAX_HP)
	await _wait_respawn()
	_check(
		"checkpoint_stores_ammo",
		player.get_instance_id() == id_before
		and player.health.current == HealthGD.MAX_HP
		and player.shuriken_ammo == stored
		and is_equal_approx(player.global_position.x, shrine.global_position.x),
		"hp=%s ammo=%s x=%s activated=%s" % [
			player.health.current, player.shuriken_ammo, player.global_position.x, shrine.is_activated
		]
	)
	_teardown(world)


func _test_death_before_checkpoint() -> void:
	var world := Node2D.new()
	root.add_child(world)
	_spawn_floor(world, FLOOR_POS, FLOOR_SIZE)
	var start := Vector2(0, 158)
	var player = _spawn_combat_player(world, start)
	_attach_session(world)
	await _step_physics(4)
	player.shuriken_ammo = HealthGD.START_AMMO + HealthGD.AMMO_PICKUP
	var id_before: int = player.get_instance_id()
	player.health.take_damage(HealthGD.MAX_HP)
	await _wait_respawn()
	_check(
		"death_before_checkpoint",
		player.get_instance_id() == id_before
		and player.health.current == HealthGD.MAX_HP
		and player.shuriken_ammo == HealthGD.START_AMMO
		and is_equal_approx(player.global_position.x, start.x),
		"hp=%s ammo=%s x=%s" % [player.health.current, player.shuriken_ammo, player.global_position.x]
	)
	_teardown(world)


func _test_kill_plane_respawn() -> void:
	var world := Node2D.new()
	root.add_child(world)
	_spawn_floor(world, FLOOR_POS, FLOOR_SIZE)
	var start := Vector2(0, 158)
	var player = _spawn_combat_player(world, start)
	var plane_packed: PackedScene = load("res://scenes/kill_plane.tscn")
	var plane = plane_packed.instantiate()
	plane.position = Vector2(0, 400)
	world.add_child(plane)
	_attach_session(world)
	await _step_physics(4)
	var id_before: int = player.get_instance_id()
	player.position = plane.position
	await _step_physics(6)
	await _wait_respawn()
	_check(
		"kill_plane_respawn",
		player.get_instance_id() == id_before
		and not player.is_dead
		and player.health.current == HealthGD.MAX_HP
		and is_equal_approx(player.global_position.x, start.x),
		"dead=%s hp=%s x=%s" % [player.is_dead, player.health.current, player.global_position.x]
	)
	_teardown(world)


func _test_dead_enemy_stays_dead() -> void:
	var world := Node2D.new()
	root.add_child(world)
	_spawn_floor(world, FLOOR_POS, FLOOR_SIZE)
	var player = _spawn_combat_player(world, Vector2(0, 158))
	var thug = _spawn_combat_thug(world, Vector2(80, 158))
	_attach_session(world)
	await _step_physics(4)
	thug.health.take_damage(HealthGD.THUG_MAX_HP)
	await physics_frame
	if not thug.is_dead:
		_check("dead_enemy_stays_dead", false, "thug not dead before player death")
		_teardown(world)
		return
	player.health.take_damage(HealthGD.MAX_HP)
	await _wait_respawn()
	var start_hp: int = player.health.current
	thug.request_stab()
	await _step_physics(_frames_for(ClanThugGD.THUG_TELEGRAPH + ClanThugGD.THUG_ACTIVE + 0.1))
	_check(
		"dead_enemy_stays_dead",
		thug.is_dead and player.health.current == start_hp,
		"thug_dead=%s hp %s -> %s" % [thug.is_dead, start_hp, player.health.current]
	)
	_teardown(world)


func _test_pickup_stays_gone() -> void:
	var world := Node2D.new()
	root.add_child(world)
	_spawn_floor(world, FLOOR_POS, FLOOR_SIZE)
	var player = _spawn_combat_player(world, Vector2(0, 158))
	var pickup = _spawn_pickup_scene(world, Vector2(0, 158), "res://scenes/ammo_pickup.tscn")
	_attach_session(world)
	await _step_physics(8)
	var pickup_gone_before_death := not is_instance_valid(pickup)
	player.health.take_damage(HealthGD.MAX_HP)
	await _wait_respawn()
	_check(
		"pickup_stays_gone",
		pickup_gone_before_death and not is_instance_valid(pickup),
		"gone_before=%s valid_after=%s ammo=%s" % [
			pickup_gone_before_death, is_instance_valid(pickup), player.shuriken_ammo
		]
	)
	_teardown(world)


func _test_level_layout_order() -> void:
	var packed: PackedScene = load("res://scenes/main.tscn")
	if packed == null:
		_check("level_layout_order", false, "failed to load main.tscn")
		return
	var main := packed.instantiate()
	var dummy: Node2D = main.get_node("Dummy") as Node2D
	var z1_thug: Node2D = main.get_node("Zone1Thug") as Node2D
	var z1_thrower: Node2D = main.get_node("Zone1Thrower") as Node2D
	var shrine: Node2D = main.get_node("Checkpoint") as Node2D
	var shrine2: Node2D = main.get_node("Checkpoint2") as Node2D
	var z2_thug_a: Node2D = main.get_node("Zone2ThugA") as Node2D
	var z2_thug_b: Node2D = main.get_node("Zone2ThugB") as Node2D
	var z2_thrower: Node2D = main.get_node("Zone2Thrower") as Node2D
	var supply: Node2D = main.get_node("SupplyAmmo") as Node2D
	var arena: Node = main.get_node("Arena")
	var exit_n: Node = main.get_node("Exit")
	var level: Node = main.get_node("LevelGreybox")
	var p1: Node2D = level.get_node("Platform1") as Node2D
	var p2: Node2D = level.get_node("Platform2") as Node2D
	var p3: Node2D = level.get_node("Platform3") as Node2D
	_check("layout_dummy_x", absf(dummy.position.x - 300.0) <= 40.0, "dummy.x=%s" % dummy.position.x)
	_check(
		"layout_shrine_after_zone1",
		shrine.position.x > z1_thug.position.x and shrine.position.x > z1_thrower.position.x,
		"shrine=%s z1_thug=%s z1_thrower=%s" % [shrine.position.x, z1_thug.position.x, z1_thrower.position.x]
	)
	_check(
		"layout_arena_after_zone2",
		arena.position.x > z2_thug_a.position.x
		and arena.position.x > z2_thug_b.position.x
		and arena.position.x > z2_thrower.position.x,
		"arena=%s" % arena.position.x
	)
	_check(
		"layout_shrine2_before_arena",
		shrine2.position.x > supply.position.x and shrine2.position.x < arena.position.x,
		"shrine2=%s supply=%s arena=%s" % [shrine2.position.x, supply.position.x, arena.position.x]
	)
	_check(
		"layout_exit_after_arena",
		exit_n.position.x > arena.position.x,
		"exit=%s arena=%s" % [exit_n.position.x, arena.position.x]
	)
	_check(
		"layout_platforms_after_shrine",
		p1.position.x > shrine.position.x
		and p2.position.x > shrine.position.x
		and p3.position.x > shrine.position.x,
		"p1=%s p2=%s p3=%s shrine=%s" % [p1.position.x, p2.position.x, p3.position.x, shrine.position.x]
	)
	main.free()


func _luma(c: Color) -> float:
	return 0.2126 * c.r + 0.7152 * c.g + 0.0722 * c.b


func _rgb_dist(a: Color, b: Color) -> float:
	return Vector3(a.r, a.g, a.b).distance_to(Vector3(b.r, b.g, b.b))


func _test_placeholder_contrast() -> void:
	_check(
		"dummy_idle_luminance",
		_luma(DummyGD.COLOR_IDLE) >= DummyGD.MIN_IDLE_LUMINANCE,
		"luma=%s" % _luma(DummyGD.COLOR_IDLE)
	)
	_check(
		"thug_idle_luminance",
		_luma(ClanThugGD.COLOR_IDLE) >= DummyGD.MIN_IDLE_LUMINANCE,
		"luma=%s" % _luma(ClanThugGD.COLOR_IDLE)
	)
	_check(
		"thrower_idle_luminance",
		_luma(ThrowFighterGD.COLOR_IDLE) >= DummyGD.MIN_IDLE_LUMINANCE,
		"luma=%s" % _luma(ThrowFighterGD.COLOR_IDLE)
	)
	_check(
		"idle_dummy_thug_distinct",
		_rgb_dist(DummyGD.COLOR_IDLE, ClanThugGD.COLOR_IDLE) >= DummyGD.MIN_IDLE_COLOR_DISTANCE,
		"dist=%s" % _rgb_dist(DummyGD.COLOR_IDLE, ClanThugGD.COLOR_IDLE)
	)
	_check(
		"idle_dummy_thrower_distinct",
		_rgb_dist(DummyGD.COLOR_IDLE, ThrowFighterGD.COLOR_IDLE) >= DummyGD.MIN_IDLE_COLOR_DISTANCE,
		"dist=%s" % _rgb_dist(DummyGD.COLOR_IDLE, ThrowFighterGD.COLOR_IDLE)
	)
	_check(
		"idle_thug_thrower_distinct",
		_rgb_dist(ClanThugGD.COLOR_IDLE, ThrowFighterGD.COLOR_IDLE) >= DummyGD.MIN_IDLE_COLOR_DISTANCE,
		"dist=%s" % _rgb_dist(ClanThugGD.COLOR_IDLE, ThrowFighterGD.COLOR_IDLE)
	)
	_assert_placeholder_scene(
		"dummy",
		"res://scenes/dummy.tscn",
		DummyGD.COLOR_IDLE,
		DummyGD.COLOR_BAND,
		DummyGD.COLOR_OUTLINE,
		DummyGD.OUTLINE_GROW,
		"BodyCollision/CollisionShape2D"
	)
	_assert_placeholder_scene(
		"thug",
		"res://scenes/clan_thug.tscn",
		ClanThugGD.COLOR_IDLE,
		ClanThugGD.COLOR_BAND,
		ClanThugGD.COLOR_OUTLINE,
		ClanThugGD.OUTLINE_GROW,
		"CollisionShape2D"
	)
	_assert_placeholder_scene(
		"thrower",
		"res://scenes/throw_fighter.tscn",
		ThrowFighterGD.COLOR_IDLE,
		ThrowFighterGD.COLOR_BAND,
		ThrowFighterGD.COLOR_OUTLINE,
		ThrowFighterGD.OUTLINE_GROW,
		"CollisionShape2D"
	)
	_assert_placeholder_scene(
		"captain",
		"res://scenes/clan_captain.tscn",
		ClanCaptainGD.COLOR_IDLE,
		ClanCaptainGD.COLOR_BAND,
		ClanCaptainGD.COLOR_OUTLINE,
		ClanCaptainGD.OUTLINE_GROW,
		"CollisionShape2D",
		ClanCaptainGD.BODY_SIZE
	)


func _assert_placeholder_scene(
	prefix: String,
	path: String,
	idle: Color,
	band: Color,
	outline_color: Color,
	grow: float,
	collision_path: String,
	collision_size: Vector2 = PLAYER_COLLISION_SIZE
) -> void:
	var packed: PackedScene = load(path)
	if packed == null:
		_check("%s_placeholder_scene" % prefix, false, "failed to load %s" % path)
		return
	var node: Node = packed.instantiate()
	var outline := node.get_node_or_null("Outline") as ColorRect
	var body := node.get_node_or_null("Body") as ColorRect
	var band_rect := node.get_node_or_null("Band") as ColorRect
	var col := node.get_node_or_null(collision_path) as CollisionShape2D
	if outline == null or body == null or band_rect == null:
		_check("%s_placeholder_nodes" % prefix, false, "missing Outline/Body/Band")
		node.free()
		return
	var outline_idx := outline.get_index()
	var body_idx := body.get_index()
	_check(
		"%s_outline_behind_body" % prefix,
		outline_idx < body_idx,
		"outline_idx=%s body_idx=%s" % [outline_idx, body_idx]
	)
	_check(
		"%s_idle_matches_const" % prefix,
		body.color.is_equal_approx(idle),
		"body=%s idle=%s" % [body.color, idle]
	)
	_check(
		"%s_band_matches_const" % prefix,
		band_rect.color.is_equal_approx(band),
		"band=%s const=%s" % [band_rect.color, band]
	)
	_check(
		"%s_outline_color" % prefix,
		outline.color.is_equal_approx(outline_color),
		"outline=%s const=%s" % [outline.color, outline_color]
	)
	var expected_outline := body.size + Vector2(grow * 2.0, grow * 2.0)
	_check(
		"%s_outline_grow" % prefix,
		outline.size.is_equal_approx(expected_outline),
		"outline.size=%s expected=%s" % [outline.size, expected_outline]
	)
	if col == null or col.shape == null or not (col.shape is RectangleShape2D):
		_check("%s_collision_size" % prefix, false, "missing RectangleShape2D")
	else:
		_check(
			"%s_collision_size" % prefix,
			(col.shape as RectangleShape2D).size.is_equal_approx(collision_size),
			"size=%s" % (col.shape as RectangleShape2D).size
		)
	node.free()


func _spawn_combat_captain(world: Node, pos: Vector2):
	var packed: PackedScene = load("res://scenes/clan_captain.tscn")
	var captain = packed.instantiate()
	captain.auto_aggro = false
	captain.name = "Captain"
	captain.position = pos
	world.add_child(captain)
	return captain


func _make_wall(world: Node, pos: Vector2, wall_name: String) -> StaticBody2D:
	var wall := StaticBody2D.new()
	wall.name = wall_name
	wall.position = pos
	wall.collision_layer = 0
	wall.collision_mask = 0
	var shape_node := CollisionShape2D.new()
	shape_node.name = "CollisionShape2D"
	var rect := RectangleShape2D.new()
	rect.size = Vector2(40, 180)
	shape_node.shape = rect
	shape_node.disabled = false
	world.add_child(wall)
	wall.add_child(shape_node)
	if wall_name == "LeftWall":
		wall.add_to_group("arena_left_wall")
	else:
		wall.add_to_group("arena_right_wall")
	return wall


func _make_player_area(world: Node, pos: Vector2, name_hint: String) -> Area2D:
	var area := Area2D.new()
	area.name = name_hint
	area.position = pos
	area.collision_layer = 0
	area.collision_mask = 2
	area.monitoring = true
	area.monitorable = false
	var shape_node := CollisionShape2D.new()
	var rect := RectangleShape2D.new()
	rect.size = Vector2(48, 80)
	shape_node.shape = rect
	area.add_child(shape_node)
	world.add_child(area)
	return area


func _make_arena(
	world: Node,
	captain: Node,
	enter: Area2D,
	exit_area: Area2D,
	left_wall: StaticBody2D,
	right_wall: StaticBody2D
) -> ArenaController:
	var overlay = (load("res://scenes/outcome_overlay.tscn") as PackedScene).instantiate()
	overlay.name = "OutcomeOverlay"
	world.add_child(overlay)
	var hp_bar = (load("res://scenes/boss_hp_bar.tscn") as PackedScene).instantiate()
	hp_bar.name = "BossHpBar"
	world.add_child(hp_bar)
	var arena: ArenaController = ArenaControllerGD.new()
	world.add_child(arena)
	arena.name = "ArenaController"
	arena.boss_path = NodePath("../%s" % captain.name)
	arena.enter_path = NodePath("../%s" % enter.name)
	arena.exit_path = NodePath("../%s" % exit_area.name)
	arena.left_wall_path = NodePath("../%s" % left_wall.name)
	arena.right_wall_path = NodePath("../%s" % right_wall.name)
	arena.overlay_path = NodePath("../OutcomeOverlay")
	arena.hp_bar_path = NodePath("../BossHpBar")
	return arena


func _overlay_label(world: Node) -> Label:
	var overlay := world.get_node_or_null("OutcomeOverlay")
	if overlay == null:
		return null
	return overlay.get_node_or_null("Label") as Label


func _hp_bar_visible(world: Node) -> bool:
	var bar := world.get_node_or_null("BossHpBar") as CanvasLayer
	return bar != null and bar.visible


func _test_second_shrine_overrides_spawn() -> void:
	var world := Node2D.new()
	root.add_child(world)
	_spawn_floor(world, FLOOR_POS, FLOOR_SIZE)
	var player = _spawn_combat_player(world, Vector2(0, 158))
	var shrine_packed: PackedScene = load("res://scenes/checkpoint.tscn")
	var shrine1 = shrine_packed.instantiate()
	shrine1.position = Vector2(40, 158)
	world.add_child(shrine1)
	var shrine2 = shrine_packed.instantiate()
	shrine2.position = Vector2(160, 158)
	world.add_child(shrine2)
	_attach_session(world)
	await _step_physics(4)
	player.shuriken_ammo = HealthGD.START_AMMO + HealthGD.AMMO_PICKUP
	player.position = shrine1.position
	await _step_physics(6)
	var second_ammo: int = mini(HealthGD.START_AMMO + HealthGD.AMMO_PICKUP * 2, HealthGD.MAX_AMMO)
	player.shuriken_ammo = second_ammo
	player.position = shrine2.position
	await _step_physics(6)
	if not shrine2.is_activated:
		_check("second_shrine_overrides_spawn", false, "shrine2 did not activate")
		_teardown(world)
		return
	player.health.take_damage(HealthGD.MAX_HP)
	await _wait_respawn()
	_check(
		"second_shrine_overrides_spawn",
		player.shuriken_ammo == second_ammo
		and is_equal_approx(player.global_position.x, shrine2.global_position.x),
		"ammo=%s x=%s" % [player.shuriken_ammo, player.global_position.x]
	)
	_teardown(world)


func _test_arena_lock_blocks_left() -> void:
	var world := Node2D.new()
	root.add_child(world)
	_spawn_floor(world, FLOOR_POS, FLOOR_SIZE)
	var player = _spawn_combat_player(world, Vector2(220, 158))
	var captain = _spawn_combat_captain(world, Vector2(400, 158))
	var enter := _make_player_area(world, Vector2(220, 158), "Arena")
	var exit_area := _make_player_area(world, Vector2(700, 158), "Exit")
	var left_wall := _make_wall(world, Vector2(80, 160), "LeftWall")
	var right_wall := _make_wall(world, Vector2(640, 160), "RightWall")
	_make_arena(world, captain, enter, exit_area, left_wall, right_wall)
	await _step_physics(6)
	var arena := world.get_node("ArenaController") as ArenaController
	if arena == null:
		_check("arena_lock_blocks_left", false, "missing ArenaController")
		_teardown(world)
		return
	if not arena.is_locked or not arena.is_left_wall_closed() or not arena.is_right_wall_closed():
		_check(
			"arena_lock_blocks_left",
			false,
			"enter did not lock locked=%s left=%s right=%s" % [
				arena.is_locked,
				arena.is_left_wall_closed(),
				arena.is_right_wall_closed(),
			]
		)
		_teardown(world)
		return
	if not _hp_bar_visible(world):
		_check("arena_lock_blocks_left", false, "hp bar hidden after lock")
		_teardown(world)
		return
	player.set_move_axis(-1.0)
	await _step_physics(80)
	_check(
		"arena_lock_blocks_left",
		player.global_position.x > 105.0 and arena.is_left_wall_closed(),
		"x=%s left_closed=%s layer=%s" % [
			player.global_position.x,
			arena.is_left_wall_closed(),
			left_wall.collision_layer,
		]
	)
	_teardown(world)


func _test_stomp_hits_player() -> void:
	var world := Node2D.new()
	root.add_child(world)
	_spawn_floor(world, FLOOR_POS, FLOOR_SIZE)
	var player = _spawn_combat_player(world, Vector2(0, 158))
	var captain = _spawn_combat_captain(world, Vector2(40, 158))
	await _step_physics(4)
	var start_hp: int = player.health.current
	captain.request_stomp()
	await _step_physics(_frames_for(ClanCaptainGD.STOMP_TELEGRAPH + ClanCaptainGD.STOMP_ACTIVE))
	_check(
		"stomp_hits_player",
		player.health.current == start_hp - HealthGD.BOSS_STOMP_DAMAGE,
		"hp %s -> %s" % [start_hp, player.health.current]
	)
	_teardown(world)


func _test_dodge_blocks_stomp() -> void:
	var world := Node2D.new()
	root.add_child(world)
	_spawn_floor(world, FLOOR_POS, FLOOR_SIZE)
	var player = _spawn_combat_player(world, Vector2(0, 158))
	var captain = _spawn_combat_captain(world, Vector2(40, 158))
	await _step_physics(4)
	var start_hp: int = player.health.current
	captain.request_stomp()
	var telegraph_frames := maxi(
		int(floor(ClanCaptainGD.STOMP_TELEGRAPH * float(Engine.physics_ticks_per_second))) - 1, 1
	)
	await _step_physics(telegraph_frames)
	player.request_dodge()
	await _step_physics(_frames_for(ClanCaptainGD.STOMP_ACTIVE + 0.05))
	_check(
		"dodge_blocks_stomp",
		player.health.current == start_hp,
		"hp %s -> %s" % [start_hp, player.health.current]
	)
	_teardown(world)


func _test_exit_without_boss_dead_no_win() -> void:
	var world := Node2D.new()
	root.add_child(world)
	_spawn_floor(world, FLOOR_POS, FLOOR_SIZE)
	var player = _spawn_combat_player(world, Vector2(80, 158))
	var captain = _spawn_combat_captain(world, Vector2(200, 158))
	var enter := _make_player_area(world, Vector2(-80, 158), "Arena")
	var exit_area := _make_player_area(world, Vector2(80, 158), "Exit")
	var left_wall := _make_wall(world, Vector2(-40, 160), "LeftWall")
	var right_wall := _make_wall(world, Vector2(320, 160), "RightWall")
	var arena := _make_arena(world, captain, enter, exit_area, left_wall, right_wall)
	await _step_physics(8)
	_check(
		"exit_without_boss_dead_no_win",
		not arena.is_won and not captain.is_dead,
		"won=%s dead=%s" % [arena.is_won, captain.is_dead]
	)
	_teardown(world)


func _test_boss_dead_opens_right_wall() -> void:
	var world := Node2D.new()
	root.add_child(world)
	_spawn_floor(world, FLOOR_POS, FLOOR_SIZE)
	var player = _spawn_combat_player(world, Vector2(200, 158))
	var captain = _spawn_combat_captain(world, Vector2(280, 158))
	var enter := _make_player_area(world, Vector2(200, 158), "Arena")
	var exit_area := _make_player_area(world, Vector2(700, 158), "Exit")
	var left_wall := _make_wall(world, Vector2(80, 160), "LeftWall")
	var right_wall := _make_wall(world, Vector2(640, 160), "RightWall")
	var arena := _make_arena(world, captain, enter, exit_area, left_wall, right_wall)
	await _step_physics(6)
	if not arena.is_locked:
		_check("boss_dead_opens_right_wall", false, "enter did not lock")
		_teardown(world)
		return
	captain.health.take_damage(HealthGD.BOSS_MAX_HP)
	await physics_frame
	_check(
		"boss_dead_opens_right_wall",
		captain.is_dead
		and not arena.is_right_wall_closed()
		and arena.is_left_wall_closed()
		and not _hp_bar_visible(world),
		"dead=%s right=%s left=%s bar=%s" % [
			captain.is_dead,
			arena.is_right_wall_closed(),
			arena.is_left_wall_closed(),
			_hp_bar_visible(world),
		]
	)
	_teardown(world)


func _test_victory_on_exit_after_boss() -> void:
	var world := Node2D.new()
	root.add_child(world)
	_spawn_floor(world, FLOOR_POS, FLOOR_SIZE)
	var player = _spawn_combat_player(world, Vector2(80, 158))
	var captain = _spawn_combat_captain(world, Vector2(200, 158))
	var enter := _make_player_area(world, Vector2(-80, 158), "Arena")
	var exit_area := _make_player_area(world, Vector2(400, 158), "Exit")
	var left_wall := _make_wall(world, Vector2(-40, 160), "LeftWall")
	var right_wall := _make_wall(world, Vector2(320, 160), "RightWall")
	var arena := _make_arena(world, captain, enter, exit_area, left_wall, right_wall)
	await _step_physics(6)
	captain.health.take_damage(HealthGD.BOSS_MAX_HP)
	await physics_frame
	var id_before: int = player.get_instance_id()
	player.position = exit_area.position
	await _step_physics(8)
	var label := _overlay_label(world)
	_check(
		"victory_on_exit_after_boss",
		arena.is_won
		and player.get_instance_id() == id_before
		and player.control_locked
		and label != null
		and label.text == "Sieg",
		"won=%s locked=%s overlay=%s" % [
			arena.is_won,
			player.control_locked,
			label.text if label else "",
		]
	)
	_teardown(world)


func _test_death_resets_live_boss() -> void:
	var world := Node2D.new()
	root.add_child(world)
	_spawn_floor(world, FLOOR_POS, FLOOR_SIZE)
	var shrine_pos := Vector2(0, 158)
	var player = _spawn_combat_player(world, shrine_pos)
	var shrine = (load("res://scenes/checkpoint.tscn") as PackedScene).instantiate()
	shrine.position = shrine_pos
	world.add_child(shrine)
	var captain = _spawn_combat_captain(world, Vector2(200, 158))
	var enter := _make_player_area(world, Vector2(80, 158), "Arena")
	var exit_area := _make_player_area(world, Vector2(700, 158), "Exit")
	var left_wall := _make_wall(world, Vector2(40, 160), "LeftWall")
	var right_wall := _make_wall(world, Vector2(640, 160), "RightWall")
	var arena := _make_arena(world, captain, enter, exit_area, left_wall, right_wall)
	_attach_session(world)
	await _step_physics(6)
	if not shrine.is_activated:
		_check("death_resets_live_boss", false, "shrine did not activate")
		_teardown(world)
		return
	player.position = enter.position
	await _step_physics(6)
	captain.health.take_damage(HealthGD.BOSS_STOMP_DAMAGE)
	var wounded: int = captain.health.current
	player.health.take_damage(HealthGD.MAX_HP)
	await physics_frame
	var defeat_label := _overlay_label(world)
	if defeat_label == null or defeat_label.text != "Niederlage":
		_check(
			"death_resets_live_boss",
			false,
			"overlay=%s" % (defeat_label.text if defeat_label else "")
		)
		_teardown(world)
		return
	await _wait_respawn()
	var after_label := _overlay_label(world)
	_check(
		"death_resets_live_boss",
		wounded < HealthGD.BOSS_MAX_HP
		and captain.health.current == HealthGD.BOSS_MAX_HP
		and not arena.is_left_wall_closed()
		and not arena.is_right_wall_closed()
		and not captain.is_dead
		and not _hp_bar_visible(world)
		and after_label != null
		and after_label.text == ""
		and is_equal_approx(player.global_position.x, shrine.global_position.x),
		"wounded=%s hp=%s left=%s right=%s x=%s overlay=%s" % [
			wounded,
			captain.health.current,
			arena.is_left_wall_closed(),
			arena.is_right_wall_closed(),
			player.global_position.x,
			after_label.text if after_label else "",
		]
	)
	_teardown(world)

