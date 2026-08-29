class_name OutcomeOverlay
extends CanvasLayer

var _label: Label


func _ready() -> void:
	layer = 20
	_label = get_node_or_null("Label") as Label
	hide_outcome()


func show_victory() -> void:
	if _label:
		_label.text = "Sieg"
	visible = true


func show_defeat() -> void:
	if _label:
		_label.text = "Niederlage"
	visible = true


func hide_outcome() -> void:
	visible = false
	if _label:
		_label.text = ""
