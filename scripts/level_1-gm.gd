extends Node

@export var point_bar: PackedScene
@export var confirm_button: Button
@export var points_label: Label

@onready var game: Node2D = $".."
@onready var bar: Area2D = $"../Board/Selection_panel/bar"
@onready var selection_panel: Panel = $"../Board/Selection_panel"

signal end_level


var is_draggable = false
var is_pressed = false
var cnt = 0
var bar_value: int
var node_path: String

func setup_colour_bars() -> void:
	var new_bar = null
	
	for bar_idx in range(5):
		new_bar = point_bar.instantiate()
		new_bar.position = bar.position + Vector2(48 * bar_idx, 0)
		var type = new_bar.bar_type[bar_idx].name
		new_bar.set_type(type)
		new_bar.input_event.connect(_on_bar_input_event.bind(type))
		selection_panel.add_child(new_bar)
		var path = new_bar.get_path()
		new_bar.mouse_entered.connect(_on_bar_mouse_entered.bind(path))
		new_bar.mouse_exited.connect(_on_bar_mouse_exited.bind(path))
		

func setup_white_bars() -> void:
	var new_bar = null
	
	for bar_idx in range(5, 9):
		new_bar = point_bar.instantiate()
		new_bar.position = bar.position + Vector2(48 * (bar_idx - 5), 0)
		var type = new_bar.bar_type[bar_idx].name
		new_bar.set_type(type)
		new_bar.input_event.connect(_on_bar_input_event.bind(type))
		selection_panel.add_child(new_bar)
		var path = new_bar.get_path()
		new_bar.mouse_entered.connect(_on_bar_mouse_entered.bind(path))
		new_bar.mouse_exited.connect(_on_bar_mouse_exited.bind(path))

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#setup_colour_bars()
	setup_white_bars()
	$"../AnimationPlayer".play("transition")
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if is_draggable:
		var node = get_node(node_path)
		node.position = game.get_global_mouse_position()

func _on_button_pressed() -> void:
	var nodes = get_children()
	var score = 0
	
	for node in nodes:
		if "bar" in node.name:
			score += node.get_value()
	points_label.text = "Točk: " + str(score)
	
	if score == 30000:
		end_level.emit()
	
func _on_bar_input_event(viewport: Node, event: InputEvent, shape_idx: int, type: String) -> void:
	if event.is_action_pressed("spawn"):
		var new_bar: Node = point_bar.instantiate()
		new_bar.position = game.get_global_mouse_position()
		var name = "bar" + str(cnt)
		new_bar.name = name
		new_bar.set_type(type)
		new_bar.input_event.connect(_on_bar_instance_input_event.bind(name))
		cnt += 1
		add_child(new_bar)
		new_bar.emit_signal("input_event", viewport, event, shape_idx)
	

func _on_bar_instance_input_event(viewport: Node, event: InputEvent, shape_idx: int, node_pth: String) -> void:
	if event.is_action_pressed("spawn"):
		is_draggable = true
		node_path = scene_file_path + node_pth
		
	if event.is_action_released("spawn"):
		is_draggable = false
	
	if event.is_action_pressed("delete"):
		node_path = scene_file_path + node_pth
		var node = get_node(node_path)
		node.queue_free()
	


func _on_bar_mouse_entered(path: String) -> void:
	var node = get_node(path)
	node.scale = Vector2(0.55, 0.55)
	pass # Replace with function body.


func _on_bar_mouse_exited(path: String) -> void:
	var node = get_node(path)
	node.scale = Vector2(0.5, 0.5)
	pass # Replace with function body.
