extends Node
class_name GlobalClass

var current_level_index

var game_scene : Game

func get_current_level_index():
	return current_level_index

func switch_to_level(new_index : int):
	current_level_index = new_index
	get_tree().change_scene_to_file("res://src/main/game.tscn")

func get_game_scene():
	return game_scene

func get_player():
	return game_scene.current_level.get_player()
