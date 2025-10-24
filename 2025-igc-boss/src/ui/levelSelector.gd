extends Button
class_name LevelSelector

var level_number = 1

func set_level_number(new_level_number):
	level_number = new_level_number
	text = "Level " + str(level_number)

func _on_pressed() -> void:
	Global.switch_to_level(level_number)
