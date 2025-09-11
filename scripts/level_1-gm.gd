extends CanvasLayer

@export var point_stick: PackedScene
@export var confirm_button: Button
@export var select_colour_button: Button
@export var select_white_button: Button

@onready var game: Node2D = $".."
@onready var stick: Area2D = %stick
@onready var selection_panel: Panel = %Selection_panel
@onready var colour_picker_screen: CanvasLayer = %ColourPickerLayer
@onready var practice_layer: CanvasLayer = %PracticeLayer
@onready var level_over_layer: CanvasLayer = %LevelOverLayer
@onready var level_over_panel: Level_over_panel = %LevelOverPanel

## Emitted at the end of the level to show if we advance to the 
## next level or not.
signal level_ended(next_level: bool)


var is_draggable = false
var is_pressed = false
var cnt = 0
var stick_value: int
var node_path: String
var point_stick_selection: point_stick_selection_enum
var level_cleared = true

enum point_stick_selection_enum
{
	COLOUR_STICKS,
	WHITE_STICKS
}

func setup_colour_sticks() -> void:
	var new_stick = null
	point_stick_selection = point_stick_selection_enum.COLOUR_STICKS
	
	for stick_idx in range(5):
		new_stick = point_stick.instantiate()
		new_stick.position = stick.position + Vector2(48 * stick_idx, 0)
		var type = new_stick.stick_type[stick_idx].name
		new_stick.set_type(type)
		new_stick.input_event.connect(_on_stick_input_event.bind(type))
		selection_panel.add_child(new_stick)
		var path = new_stick.get_path()
		new_stick.mouse_entered.connect(_on_stick_mouse_entered.bind(path))
		new_stick.mouse_exited.connect(_on_stick_mouse_exited.bind(path))

func setup_white_sticks() -> void:
	var new_stick = null
	point_stick_selection = point_stick_selection_enum.WHITE_STICKS
	
	for stick_idx in range(5, 9):
		new_stick = point_stick.instantiate()
		new_stick.position = stick.position + Vector2(48 * (stick_idx - 5), 0)
		var type = new_stick.stick_type[stick_idx].name
		new_stick.set_type(type)
		new_stick.input_event.connect(_on_stick_input_event.bind(type))
		selection_panel.add_child(new_stick)
		var path = new_stick.get_path()
		new_stick.mouse_entered.connect(_on_stick_mouse_entered.bind(path))
		new_stick.mouse_exited.connect(_on_stick_mouse_exited.bind(path))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if select_colour_button.button_pressed:
		#select_colour_button.button_pressed = false
		colour_picker_screen.visible = false
		setup_colour_sticks()
	elif select_white_button.button_pressed:
		#select_white_button.button_pressed = false
		setup_white_sticks()
		colour_picker_screen.visible = false
	if is_draggable:
		var node = get_node(node_path)
		node.position = game.get_global_mouse_position()

func _on_confirm_button_pressed() -> void:
	var nodes = get_children()
	var sticks := {"10000": 0,
				  "5000": 0,
				  "1000": 0,
				  "500": 0,
				  "100": 0}
	level_cleared = true

	for node in nodes:
		if "stick" in node.name:
			var points = node.get_value()
			sticks[str(points)] += 1

	if sticks["10000"] != 1:
		level_cleared = false
	elif sticks["5000"] != 3:
		level_cleared = false
	elif sticks["1000"] != 4:
		level_cleared = false
	elif sticks["500"] != 1 and point_stick_selection == point_stick_selection_enum.COLOUR_STICKS:
		level_cleared = false
	elif sticks["100"] != 5 and point_stick_selection == point_stick_selection_enum.COLOUR_STICKS:
		level_cleared = false
	elif sticks["100"] != 10 and point_stick_selection == point_stick_selection_enum.WHITE_STICKS:
		level_cleared = false
	
	if level_cleared:
		level_over_panel.on_level_over(true)
	else:
		level_over_panel.on_level_over(false)
	
	for node in get_children():
		node.queue_free()
		
	practice_layer.visible = false
	level_over_layer.visible = true

func _on_stick_input_event(viewport: Node, event: InputEvent, shape_idx: int, type: String) -> void:
	if event.is_action_pressed("spawn"):
		var new_stick: Node = point_stick.instantiate()
		new_stick.position = game.get_global_mouse_position()
		var instance_name = "stick" + str(cnt)
		new_stick.name = instance_name
		new_stick.set_type(type)
		new_stick.input_event.connect(_on_stick_instance_input_event.bind(instance_name))
		cnt += 1
		add_child(new_stick)
		new_stick.emit_signal("input_event", viewport, event, shape_idx)

func _on_stick_instance_input_event(_viewport: Node, event: InputEvent, _shape_idx: int, node_pth: String) -> void:
	if event.is_action_pressed("spawn"):
		is_draggable = true
		node_path = scene_file_path + node_pth
		
	if event.is_action_released("spawn"):
		is_draggable = false
	
	if event.is_action_pressed("delete"):
		node_path = scene_file_path + node_pth
		var node = get_node(node_path)
		node.queue_free()

func _on_stick_mouse_entered(path: String) -> void:
	var node = get_node(path)
	node.scale = Vector2(0.55, 0.55)

func _on_stick_mouse_exited(path: String) -> void:
	var node = get_node(path)
	node.scale = Vector2(0.5, 0.5)

func _on_level_over_button_pressed() -> void:
	level_ended.emit(level_cleared)
