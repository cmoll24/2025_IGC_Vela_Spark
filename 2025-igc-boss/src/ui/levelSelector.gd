extends Button
class_name LevelSelector

var level_file_path = "res://src/levels/level_1V{level_num}.tscn"

var level_number = 1

func set_level_number(new_level_number):
	#var level_scene : PackedScene = load(level_file_path.format({"level_num" : new_level_number}))
	#var level : Level = level_scene.instantiate()
	
	level_number = new_level_number
	text = "Level " + str(new_level_number)

func _on_pressed() -> void:
	Global.switch_to_level(level_number)
