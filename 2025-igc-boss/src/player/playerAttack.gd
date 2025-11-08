extends Node
class_name PlayerAttack

@export var player : Player

@export var attackbox : Area2D
@export var attack_look_ahead : Area2D

var enemies_attacked_during_dash : Array = []

func _ready() -> void:
	attackbox.body_entered.connect(_on_player_attackbox_body_entered)
	attackbox.body_exited.connect(_on_player_attackbox_body_exited)
	
func try_dash_attack():
	for x in attackbox.get_overlapping_bodies():
		if (x is Enemy or x is Boss) and not has_attacked(x):
			#print('already collided start dash attack')
			check_attack_body(x)

func chain_dash_attack() -> bool:
	for x in attack_look_ahead.get_overlapping_bodies():
		if (x is Enemy or x is Boss) and not player.move_control.dash_state and not has_attacked(x):
			#print('chain dash')
			player.move_control.continue_dash()
			return true
	return false

func check_end_dash():
	for x in attack_look_ahead.get_overlapping_bodies():
		if (x is Enemy or x is Boss):
			return
	#print('no more overlapping enemies')
	player.move_control.end_dash_attack()

func _on_player_attackbox_body_entered(body : Node2D) -> void:
	if player.move_control.dash_state and (body is Enemy or body is Boss):
		#print('collide start dash attack')
		check_attack_body(body)

func check_attack_body(body : Node2D):
	if body is Enemy or body is Boss:
		#print('attack', body)
		if not player.move_control.dash_attack_state:
			player.move_control.dash_attack()
		body.hit(player)
		enemies_attacked_during_dash.append(body)

func _on_player_attackbox_body_exited(body : Node2D) -> void:
	if player.move_control.dash_attack_state and (body is Enemy or body is Boss):
		#print('exit enemy end dash attack')
		player.move_control.end_dash_attack()

func has_attacked(enemy : Node2D):
	return enemy in enemies_attacked_during_dash
	
func reset_dash():
	enemies_attacked_during_dash.clear()

#func attack(body : Node2D):
#	if body is Enemy or body is Boss:
#		body.hit(player)
