extends Node

@export var levels: Array[PackedScene]
var level: Node
var level_number = 0
@onready var start_screen: Control = $"../StartScreen"
@onready var version_label: Label = %VersionLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	version_label.text = "Verzija " + ProjectSettings.get_setting("application/config/version")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_level_ended() -> void:
	print("End of level")
	remove_child(level)
	level_number += 1
	if len(levels) > level_number:
		level = levels[level_number].instantiate()
		var gm = level.get_node("GameManager")
		gm.level_ended.connect(_on_level_ended)
		add_child(level)
	else:
		start_screen.visible = true

func _on_beginner_button_pressed() -> void:
	level_number = 0
	level = levels[level_number].instantiate()
	var gm = level.get_node("GameManager")
	gm.level_ended.connect(_on_level_ended)
	add_child(level)
	start_screen.visible = false


func _on_intermediate_button_pressed() -> void:
	pass # Replace with function body.


func _on_expert_button_pressed() -> void:
	pass # Replace with function body.
