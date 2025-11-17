extends CharacterBody2D
class_name Boss

@onready var state_machine : BossStateMachine = $Phase1StateMachine

@onready var right_wall_check : RayCast2D = $RightWallCheck
@onready var right_wall_check_2 : RayCast2D = $RightWallCheck2
@onready var left_wall_check : RayCast2D = $LeftWallCheck
@onready var left_wall_check_2 : RayCast2D = $LeftWallCheck2

@onready var animated_sprite = $flippable/AnimatedSprite2D

@export_category("Movement variables")
@export var MOVE_SPEED : float = 100.0
@export var H_DECELERATION : float = 30
@export var GRAVITY : float = 1000.0

@export var boss_positions : Array[Vector2]
@export var minions : Array[Enemy]
var pos_cycle_order = [0,1,3,1,0,2]
var minion_spawn_info : Array

@export var ARENA_MIDDLE = 1800
@export var ARENA_VERTICAL = 500

var current_cycle_index : int = 0

var health : int = 18	
var invulnerable = false

var facing_direction : int = 1

var player : Player

func _ready() -> void:
	for x in minions:
		var minion_info = [x.global_position, x.get_scene_file_path()]
		print(minion_info)
		minion_spawn_info.append(minion_info)
	respawn_minions()
	state_machine.transition_to("TeleportState")

func setup_with_player(current_player : Player):
	player = current_player
	face_player()

func respawn_minions():
	for i in range(len(minions)):
		if minions[i] and minions[i].health > 0:
			continue
			
		var info = minion_spawn_info[i]
		var pos = info[0]
		var scene = info[1]
		var new_minion : Enemy = load(scene).instantiate()
		Global.get_game_scene().current_level.get_enemy_tree().add_child(new_minion)
		new_minion.global_position = pos
		minions[i] = new_minion

func kill_minions():
	print('Kill all minions')
	for x in minions:
		if x and x.health > 0:
			x.die()

func get_next_boss_position():
	return boss_positions[pos_cycle_order[current_cycle_index]]

func increase_boss_pos_index():
	current_cycle_index += 1
	if current_cycle_index >= len(pos_cycle_order):
		current_cycle_index = 0

func switch_to_random_state():
	state_machine.transition_to(state_machine.states.keys().pick_random())

func _physics_process(_delta: float) -> void:
	$flippable.scale.x = facing_direction

func face_player():
	facing_direction = sign( player.global_position.x - global_position.x)

func face_middle():
	facing_direction = sign(ARENA_MIDDLE - global_position.x)

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

func is_combat_phase(pos = null) -> bool:
	if pos == null:
		pos = global_position
	return pos.y > ARENA_VERTICAL

func take_damage(amount: int) -> void:
	health = max(health - amount, 0)
	
	if health <= 0:
		die()

	
	if state_machine.is_current_state("TeleportState"):
		return
	
	var choice = randi_range(0,99)
	
	if not is_combat_phase():
		choice = 0
	
	if choice < 30:
		state_machine.transition_to("TeleportState")
	else:
		state_machine.transition_to("ChargeState")

func hit(_attacker: Node2D) -> void:
	take_damage(1)

func die():
	player.health_control.full_heal()
	player.health_decay = false
	queue_free()

func play_animation(new_anim : String):
	if animated_sprite:
		animated_sprite.play(new_anim)

func _on_animated_sprite_2d_animation_finished() -> void:
	animated_sprite.play("idle")
