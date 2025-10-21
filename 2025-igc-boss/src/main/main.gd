extends Control

@onready var level_container = $VBoxContainer
@onready var level_selector = preload("res://src/ui/levelSelector.tscn")

func _ready() -> void:
	var number_of_levels = 9
	for i in range(1,number_of_levels+1):
		var level_button = level_selector.instantiate()
		level_button.set_level_number(i)
		level_container.add_child(level_button)
		
		if i == 1:
			level_button.grab_focus()
