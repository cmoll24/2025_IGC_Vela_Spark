extends Control

@onready var level_container = $VBoxContainer
@onready var level_selector = preload("res://src/ui/levelSelector.tscn")

var current_level : Level

func _ready() -> void:
	var number_of_levels = 4
	var buttons = []
	for i in range(1,number_of_levels+1):
		var level_button : LevelSelector = level_selector.instantiate()
		level_button.set_level_number(i)
		level_container.add_child(level_button)
		buttons.append(level_button)
		
		
	buttons[0].grab_focus()
	buttons[0].focus_neighbor_top = buttons[-1].get_path()
	buttons[-1].focus_neighbor_bottom = buttons[0].get_path()

func get_level():
	return current_level
