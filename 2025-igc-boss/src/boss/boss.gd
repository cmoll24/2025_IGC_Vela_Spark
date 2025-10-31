extends CharacterBody2D
class_name Boss

@onready var state_machine : BossStateMachine = $Phase1StateMachine

@export_category("Movement variables")
@export var MOVE_SPEED : float = 100.0
@export var H_DECELERATION : float = 10
@export var GRAVITY : float = 1000.0

@export var boss_positions : Array[Vector2]
var current_pos_index : int = -1

var health : int = 8

func get_next_boss_position():
	current_pos_index += 1
	if current_pos_index >= len(boss_positions):
		current_pos_index = 0
	
	return boss_positions[current_pos_index]

func switch_to_random_state():
	state_machine.transition_to(state_machine.states.keys().pick_random())

func _on_boss_hitbox_body_entered(_body: Node2D) -> void:
	pass
	#if body is Player:
	#	body.damage(self)

func take_damage(amount: int) -> void:
	health = max(health - amount, 0)
	
	if not state_machine.is_current_state("TeleportState"):
		state_machine.transition_to("TeleportState")

	if health <= 0:
		die()

func hit(_attacker: Node2D) -> void:
	take_damage(1)

func die():
	Global.get_player().health_control.full_heal()
	queue_free()
