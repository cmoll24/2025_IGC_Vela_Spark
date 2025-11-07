extends Control
class_name Game

var level_file_path = "res://src/levels/level_1V{level_num}.tscn"

@onready var level_container = $level_container
@onready var hud = $HUD

var current_level : Level

func _ready() -> void:
	Global.game_scene = self
	
	var current_level_index = Global.get_current_level_index()
	var level_scene : PackedScene = load(level_file_path.format({"level_num" : current_level_index}))
	current_level = level_scene.instantiate()
	level_container.add_child(current_level)
	
	hud.setup()
func load_next_level() -> void:
	var current_level_index = Global.get_current_level_index()
	current_level_index += 1
	Global.current_level_index = current_level_index
	current_level.queue_free()
	var level_scene : PackedScene = load(level_file_path.format({"level_num" : current_level_index}))
	current_level = level_scene.instantiate()
	level_container.add_child(current_level)
	current_level.get_player().health_control.health = Global.player_health
