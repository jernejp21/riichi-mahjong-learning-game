class_name Point_bar

extends Area2D

@export var bar_type: Array[Sprite2D]

func set_type(type: String) -> void:
	get_node(type).visible = true
	
func get_type() -> String:
	var nodes = get_children()
	var name = ""
	for node in nodes:
		if node.visible:
			name = node.name
			break
	return name
	
func get_value() -> int:
	var name = get_type()
	var node = get_node(name)
	var value = node.get_meta("value")
	return value

func _ready() -> void:
	#$colour_10000.visible = false
	#$colour_5000.visible = true
	pass

func _process(delta: float) -> void:
	pass
