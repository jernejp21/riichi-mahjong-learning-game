class_name Level_over_panel
extends PanelContainer

#@export var level_cleared: bool = false
@onready var level_over_title: Label = %LevelOverTitle
@onready var level_over_button: Button = %LevelOverButton

signal  level_over_button_pressed

func on_level_over(level_cleared: bool):
	if level_cleared:
		level_over_title.text = "Pravilno"
		level_over_button.text = "Naslednje vprašanje"
	else:
		level_over_title.text = "Napačno"
		level_over_button.text = "Ponovi vprašanje"


func _on_level_over_button_pressed() -> void:
	level_over_button_pressed.emit()
