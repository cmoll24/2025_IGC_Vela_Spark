extends Node2D
class_name Level

@onready var player = $Player
@onready var player_path = $Line2D
@onready var projectile_tree = $ProjectileTree

@export var level_name : String

func _process(_delta: float) -> void:
	var current_player_pos = player.global_position
	
	player_path.add_point(current_player_pos)
	if player_path.get_point_count() > 500:
		player_path.remove_point(0)

func get_player() -> Player:
	return player

func get_projectile_tree() -> Node2D:
	return projectile_tree
