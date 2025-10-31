extends Button
class_name LevelSelector

var level_file_path = "res://src/levels/level_1V{level_num}.tscn"

var level_number = 1

func set_level_number(new_level_number):
	var level_scene : PackedScene = load(level_file_path.format({"level_num" : new_level_number}))
	var level : Level = level_scene.instantiate()
	
	level_number = new_level_number
	text = level.level_name
	
	level.queue_free()

func _on_pressed() -> void:
	Global.switch_to_level(level_number)
