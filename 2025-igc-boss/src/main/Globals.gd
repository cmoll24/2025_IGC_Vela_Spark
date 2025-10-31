extends Node
class_name GlobalClass

var current_level_index

var game_scene : Game

func get_current_level_index():
	return current_level_index

func switch_to_level(new_index : int):
	print("switching to level ", new_index)
	current_level_index = new_index
	get_tree().change_scene_to_file("res://src/main/game.tscn")

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
