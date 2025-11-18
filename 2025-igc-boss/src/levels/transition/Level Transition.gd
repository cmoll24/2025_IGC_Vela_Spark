extends Area2D
 
@export var level_name : String
#@onready var level_container = $level_container
#@onready var hud = $HUD



func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		Global.player_health = body.health_control.health
		Global.get_player().move_control.apply_immobility(15)
		
		Global.get_game_scene().load_next_level()
		
		
