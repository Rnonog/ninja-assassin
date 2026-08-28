class_name Health
extends Node

const MAX_HP := 100
const LIGHT_DAMAGE := 10
const HEAVY_DAMAGE := 22
const DUMMY_DAMAGE := 25
const FREEZE_FRAME_DURATION := 0.06
const HURT_FLASH_DURATION := 0.08

signal died
signal damaged(amount: int, remaining: int)

@export var max_hp: int = MAX_HP
@export var immortal: bool = false

var current: int = MAX_HP


func _ready() -> void:
	current = max_hp


func take_damage(amount: int) -> int:
	if amount <= 0:
		return 0
	if not immortal and current <= 0:
		return 0
	var applied := amount
	if not immortal:
		applied = mini(amount, current)
	current = maxi(current - applied, 0)
	damaged.emit(applied, current)
	if not immortal and current <= 0:
		died.emit()
	return applied
