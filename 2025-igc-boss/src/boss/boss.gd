extends CharacterBody2D
class_name Boss

@onready var state_machine : BossStateMachine = $Phase1StateMachine

@export_category("Movement variables")
@export var MOVE_SPEED : float = 100.0
@export var H_DECELERATION : float = 10
@export var GRAVITY : float = 1000.0

var health : int = 4

func switch_to_random_state():
	state_machine.transition_to(state_machine.states.keys().pick_random())

func _on_boss_hitbox_body_entered(body: Node2D) -> void:
	pass
	#if body is Player:
	#	body.damage(self)

func take_damage(amount: int) -> void:
	health = max(health - amount, 0)

	if health <= 0:
		die()

func hit(_attacker: Node2D) -> void:
	take_damage(1)

func die():
	queue_free()
