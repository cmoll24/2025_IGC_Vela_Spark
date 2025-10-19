extends Button
class_name LevelSelector

var level_number = 1

var file_path = "res://src/levels/level_1V{level_num}.tscn"

func set_level_number(new_level_number):
	level_number = new_level_number
	text = "Level " + str(level_number)

func _on_pressed() -> void:
	get_tree().change_scene_to_file(file_path.format({"level_num":level_number}))
