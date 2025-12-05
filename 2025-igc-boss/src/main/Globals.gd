extends Node
class_name GlobalClass

var current_level_index

var game_scene : Game

var player_health 

var player_timer : float

enum INPUT_METHOD {
	KEYBOARD,
	CONTROLLER,
	TOUCH_SCREEN
}

var current_input_method

func _ready() -> void:
	#Engine.time_scale = 0.5
	Engine.set_max_fps(60)

func get_current_level_index():
	return current_level_index

func switch_to_level(new_index : int):
	print("switching to level ", new_index)
	current_level_index = new_index
	get_tree().change_scene_to_file("res://src/main/game.tscn")

func switch_to_respawn_level():
	reset_player_timer()
	if current_level_index >= 1:
		switch_to_level(1)
	else:
		switch_to_level(0)

func get_game_scene():
	return game_scene

func get_player():
	return game_scene.current_level.get_player()

func get_projectile_tree():
	return game_scene.current_level.get_projectile_tree()

func switch_to_title():
	print('switching back to title')
	current_level_index = null
	game_scene = null
	get_tree().change_scene_to_file("res://src/main/title.tscn")

func reset_player_timer():
	player_timer = 0

func set_input_method(new_input_method : INPUT_METHOD):
	current_input_method = new_input_method

func show_touch_screen_controls():
	return current_input_method == INPUT_METHOD.TOUCH_SCREEN
