extends Node2D

@onready var player = $Player
@onready var player_path = $Line2D

func _process(_delta: float) -> void:
	var current_player_pos = player.global_position
	
	player_path.add_point(current_player_pos)
	if player_path.get_point_count() > 100:
		player_path.remove_point(0)
