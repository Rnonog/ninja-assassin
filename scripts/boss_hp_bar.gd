class_name BossHpBar
extends CanvasLayer

var _fill: ColorRect
var _boss: ClanCaptain


func _ready() -> void:
	layer = 10
	_fill = get_node_or_null("Track/Fill") as ColorRect
	visible = false


func bind_boss(boss: ClanCaptain) -> void:
	_boss = boss
	if _boss and _boss.health and not _boss.health.damaged.is_connected(_on_damaged):
		_boss.health.damaged.connect(_on_damaged)
	_refresh()


func set_bar_visible(on: bool) -> void:
	visible = on
	if on:
		_refresh()


func _on_damaged(_amount: int, remaining: int) -> void:
	_refresh_amount(remaining)


func _refresh() -> void:
	if _boss == null or _boss.health == null:
		return
	_refresh_amount(_boss.health.current)


func _refresh_amount(remaining: int) -> void:
	if _fill == null:
		return
	var max_hp := float(Health.BOSS_MAX_HP)
	var ratio := 0.0
	if max_hp > 0.0:
		ratio = clampf(float(remaining) / max_hp, 0.0, 1.0)
	_fill.scale.x = ratio
