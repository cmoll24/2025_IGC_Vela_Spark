extends CharacterBody2D
class_name Boss

@onready var state_machine : BossStateMachine = $Phase1StateMachine

@export_category("Movement variables")
@export var MOVE_SPEED : float = 100.0
@export var H_DECELERATION : float = 10
@export var GRAVITY : float = 1000.0

func switch_to_random_state():
	state_machine.transition_to(state_machine.states.keys().pick_random())
