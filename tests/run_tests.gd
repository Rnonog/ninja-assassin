extends SceneTree

const PlayerGD := preload("res://scripts/player.gd")
const DummyGD := preload("res://scripts/dummy.gd")
const HealthGD := preload("res://scripts/health.gd")

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
