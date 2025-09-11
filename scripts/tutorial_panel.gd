extends PanelContainer

@onready var click_to_continue: MarginContainer = %"Click to continue"
@onready var chapter: Label = %Chapter
@onready var title: Label = %Title
@onready var description: Label = %Description

@export var tutorial_text: Tutorial_panel_text

func _ready() -> void:
	chapter.text = tutorial_text.chapter
	title.text = tutorial_text.title
	description.text = tutorial_text.description

func _on_timer_timeout() -> void:
	click_to_continue.visible = true


func _on_gui_input(event: InputEvent) -> void:
	if event.is_action("spawn") and click_to_continue.visible:
		visible = false
