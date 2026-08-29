class_name Health
extends Node

const MAX_HP := 100
const LIGHT_DAMAGE := 10
const HEAVY_DAMAGE := 22
const DUMMY_DAMAGE := 25
const SHURIKEN_DAMAGE := 6
const START_AMMO := 5
const AMMO_PICKUP := 3
const MAX_AMMO := 10
const HEAL_PICKUP := 30
const THUG_DAMAGE := 15
const THUG_MAX_HP := 40
const THROWER_DAMAGE := 10
const THROWER_MAX_HP := 30
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


func heal(amount: int) -> int:
	if amount <= 0:
		return 0
	if not immortal and current <= 0:
		return 0
	var room := maxi(max_hp - current, 0)
	var applied := mini(amount, room)
	if applied <= 0:
		return 0
	current += applied
	return applied


func restore_full() -> void:
	current = max_hp
