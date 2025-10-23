extends Node
class_name PlayerAttack

@export var player : Player

@export var attackbox : Area2D

func _ready() -> void:
	attackbox.body_entered.connect(_on_player_attackbox_body_entered)
	
func _on_player_attackbox_body_entered(body : Node2D) -> void:
	pass
	#print('hit',body)
	#if body is Enemy or body is Boss:
	#	body.hit(player)

func attack():
	for x in attackbox.get_overlapping_bodies():
		if x is Enemy or x is Boss:
			x.hit(player)
			return
