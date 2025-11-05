extends Node
class_name PlayerAttack

@export var player : Player

@export var attackbox : Area2D
@export var attack_look_ahead : Area2D

func _ready() -> void:
	attackbox.body_entered.connect(_on_player_attackbox_body_entered)
	attackbox.body_exited.connect(_on_player_attackbox_body_exited)
	
func check_dash_attack():
	pass
	#for x in attackbox.get_overlapping_bodies():
	#	check_attack_body(x)

func _on_player_attackbox_body_entered(body : Node2D) -> void:
	if player.move_control.dash_state and (body is Enemy or body is Boss):
		check_attack_body(body)

func check_attack_body(body : Node2D):
	if body is Enemy or body is Boss:
		player.move_control.dash_state = true
		if not player.move_control.dash_attack_state:
			player.move_control.dash_attack()
		body.hit(player)

func _on_player_attackbox_body_exited(body : Node2D) -> void:
	if player.move_control.dash_attack_state and (body is Enemy or body is Boss):
		player.move_control.end_dash_attack()

#func attack(body : Node2D):
#	if body is Enemy or body is Boss:
#		body.hit(player)
