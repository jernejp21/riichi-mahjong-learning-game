extends Node

@export var levels: Array[PackedScene]
var level: Node
var level_number = 0
@onready var main_scene_node: Node2D = $"../MainSceneNode"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_end_level() -> void:
	print("End of level")
	remove_child(level)
	level_number += 1
	if len(levels) > level_number:
		level = levels[level_number].instantiate()
		var gm = level.get_node("GameManager")
		gm.end_level.connect(_on_end_level)
		add_child(level)
	else:
		main_scene_node.visible = true

func _on_item_list_item_clicked(index: int, at_position: Vector2, mouse_button_index: int) -> void:
	if index == 0:
		level_number = 0
		level = levels[level_number].instantiate()
		var gm = level.get_node("GameManager")
		gm.end_level.connect(_on_end_level)
		add_child(level)
		main_scene_node.visible = false
