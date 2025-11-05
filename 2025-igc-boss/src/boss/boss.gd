extends CharacterBody2D
class_name Boss

@onready var state_machine : BossStateMachine = $Phase1StateMachine

@onready var right_wall_check : RayCast2D = $RightWallCheck
@onready var right_wall_check_2 : RayCast2D = $RightWallCheck2
@onready var left_wall_check : RayCast2D = $LeftWallCheck
@onready var left_wall_check_2 : RayCast2D = $LeftWallCheck2

@export_category("Movement variables")
@export var MOVE_SPEED : float = 100.0
@export var H_DECELERATION : float = 30
@export var GRAVITY : float = 1000.0

@export var boss_positions : Array[Vector2]
var current_pos_index : int = 0

var health : int = 25

func get_next_boss_position():
	return boss_positions[current_pos_index]

func increase_boss_pos_index():
	current_pos_index += 1
	if current_pos_index >= len(boss_positions):
		current_pos_index = 0

func switch_to_random_state():
	state_machine.transition_to(state_machine.states.keys().pick_random())

func _process(_delta: float) -> void:
	$Health.text = "Health: " + str(health)
	if right_wall_check.is_colliding() or right_wall_check_2.is_colliding():
		state_machine.transition_to("MoveState", -1)
	elif left_wall_check.is_colliding() or left_wall_check_2.is_colliding():
		state_machine.transition_to("MoveState", 1)

func _on_boss_hitbox_body_entered(_body: Node2D) -> void:
	pass
	#if body is Player:
	#	body.damage(self)

func take_damage(amount: int) -> void:
	health = max(health - amount, 0)
	
	if health <= 0:
		die()

	
	if state_machine.is_current_state("TeleportState"):
		return
	
	var choice = randi_range(0,99)
	
	if global_position.y < 400:
		choice = 0
	
	if choice < 60:
		state_machine.transition_to("TeleportState")
	else:
		state_machine.transition_to("ChargeState")

func hit(_attacker: Node2D) -> void:
	take_damage(1)

func die():
	Global.get_player().health_control.full_heal()
	queue_free()
