extends Control
class_name Game

var level_file_path = "res://src/levels/level_1V{level_num}.tscn"

@onready var level_container = $level_container

var current_level : Level

func _ready() -> void:
	Global.game_scene = self
	
	var current_level_index = Global.get_current_level_index()
	var level_scene : PackedScene = load(level_file_path.format({"level_num" : current_level_index}))
	current_level = level_scene.instantiate()
	level_container.add_child(current_level)
