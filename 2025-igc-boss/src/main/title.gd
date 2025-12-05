extends Control

@onready var level_container = $VBoxContainer
@onready var level_selector = preload("res://src/ui/levelSelector.tscn")

@onready var start_button = $VBoxContainer/Start

var current_level : Level

func _ready() -> void:
	start_button.grab_focus()
	#create_level_select() #DEBUG

func create_level_select() -> void:
	start_button.queue_free()
	
	var number_of_levels = 9
	var buttons = []
	for i in range(0,number_of_levels):
		var level_button : LevelSelector = level_selector.instantiate()
		level_button.set_level_number(i)
		level_container.add_child(level_button)
		buttons.append(level_button)
		
		
	buttons[0].grab_focus()
	buttons[0].focus_neighbor_top = buttons[-1].get_path()
	buttons[-1].focus_neighbor_bottom = buttons[0].get_path()

func get_level():
	return current_level


func _on_start_pressed() -> void:
	if Global.current_input_method == null:
		get_tree().change_scene_to_file("res://src/main/control_options.tscn")
	else:
		Global.switch_to_level(0)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("debug_level_select") and start_button:
		create_level_select()
