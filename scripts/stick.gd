class_name Point_bar

extends Area2D

@export var stick_type: Array[Sprite2D]

func set_type(type: String) -> void:
	get_node(type).visible = true
	
func get_type() -> String:
	var nodes = get_children()
	var node_name = ""
	for node in nodes:
		if node.visible:
			node_name = node.name
			break
	return node_name
	
func get_value() -> int:
	var node_name = get_type()
	var node = get_node(node_name)
	var value = node.get_meta("value")
	return value
