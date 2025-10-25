extends Node
class_name PlayerAttack

@export var player : Player

@export var attackbox : Area2D

func _ready() -> void:
	attackbox.body_entered.connect(_on_player_attackbox_body_entered)
	attackbox.body_exited.connect(_on_player_attackbox_body_exited)
	
func check_dash_attack():
	for x in attackbox.get_overlapping_bodies():
		_on_player_attackbox_body_entered(x)

func _on_player_attackbox_body_entered(body : Node2D) -> void:
	if player.move_control.dash_state and (body is Enemy or body is Boss):
		if not player.move_control.dash_attack_state:
			player.move_control.dash_attack()
		attack(body)
	#print('hit',body)
	#if body is Enemy or body is Boss:
	#	body.hit(player)

func _on_player_attackbox_body_exited(body : Node2D) -> void:
	if player.move_control.dash_attack_state and (body is Enemy or body is Boss):
		player.move_control.end_dash_attack()

func attack(body : Node2D):
	if body is Enemy or body is Boss:
		body.hit(player)
