extends Node
class_name PlayerMovement

@onready var jump_grace_timer = $JumpGraceTime
@onready var dash_grace_timer = $DashGraceTime
@onready var coyote_timer = $CoyoteTime
@onready var dash_attack_cooldown = $DashAttackCooldown
@onready var dash_duration = $DashDuration
@onready var dash_turn_around_timer = $DashTurnAround
@onready var immobile_timer = $ImmobileTime

@export var player : Player
@export var ground_detector : RayCast2D
@export var air_jump_detector : RayCast2D

@export var debug_label : Label

@export_category("Movement variables")
@export var MOVE_SPEED : float = 500.0
@export var H_DECELERATION : float = 10
@export var GRAVITY : float = 1200.0
@export var MAX_FALL_SPEED : float = 1500.0

@export_category("Jump variables")
@export var JUMP_SPEED : float = 800.0
@export var MAX_AIR_JUMP_AMOUNT : int = 1
var air_jump_amount : int = MAX_AIR_JUMP_AMOUNT
@export var JUMP_PEAK_RANGE : float = 20.0

@export_category("Dash variables")
var has_dash = true
var dash_state = false
var dash_attack_state = false
var dash_direction
@export var DASH_SPEED : float = 1000
var current_dash_speed = DASH_SPEED
var dash_entry_speed : float

@export_category("Knockback variables")
@export var knockback_force: float = 1000.0
@export var knockback_upward_force: float = 400.0
@export var knockback_duration: float = 0.3

var knockback_vector: Vector2 = Vector2.ZERO
var is_knocked_back: bool = false
var knockback_timer: float = 0.0

var move_input : int = 0
var current_gravity = GRAVITY
var current_move_speed = MOVE_SPEED
var is_touching_floor = false

var direction_facing = 1

var last_ground_location : Vector2

func _ready() -> void:
	last_ground_location = player.global_position

func get_player_direction():
	if immobile_timer.is_stopped() and not is_knocked_back and not player.is_dead:
		move_input = sign(Input.get_axis("move_left", "move_right"))
	else:
		move_input = 0
	if move_input != 0:
			direction_facing = sign(move_input)

func is_jump_peak():
	return player.velocity.y < JUMP_PEAK_RANGE and player.velocity.y > -JUMP_PEAK_RANGE and not player.is_on_floor()

func is_big_jump_peak():
	return player.velocity.y < JUMP_PEAK_RANGE * 10 and player.velocity.y > -JUMP_PEAK_RANGE * 10 and not player.is_on_floor()

func physics_update(delta: float) -> void:
	if is_jump_peak(): 
		current_gravity = GRAVITY / 2
	elif player.velocity.y > 0:
		current_gravity = GRAVITY * 2.5
	else:
		current_gravity = GRAVITY
	
	#Movement States
	get_player_direction()
	process_controller_dash()
	
	if is_knocked_back:
		player.velocity.y += GRAVITY * delta
		knockback_process(delta)
	else:
		if immobile_timer.is_stopped() and can_dash():
			if is_dash_just_pressed():
				dash()
			
		if dash_state or dash_attack_state:
			dash_movement(delta)
		else:
			player.velocity.y += current_gravity * delta
			horizontal_movement(delta)
			jump(delta)
	
	if is_touching_floor:
		has_dash = true
		air_jump_amount = MAX_AIR_JUMP_AMOUNT
	
	player.velocity.y = min(player.velocity.y, MAX_FALL_SPEED)
	debug_label.text = str(round(jump_grace_timer.time_left * 100)) + ' ' + str(round(dash_grace_timer.time_left * 100)) #str(player.velocity.round())
	player.move_and_slide()

	if player.is_on_floor():
		is_touching_floor = true
	elif is_touching_floor:
		is_touching_floor = false
		coyote_timer.start()
		
	if player.is_on_floor() and ground_detector.is_colliding() and player.health_control.is_safe():
		last_ground_location = player.global_position
	
	#$Debug_Label.text = "Gravity: {grav}".format({'grav' : current_gravity / 100})

var is_controller_dashed_pressed = false
func process_controller_dash():
	if immobile_timer.is_stopped() and not is_knocked_back  and not player.is_dead:
		if Input.get_action_strength("controller_dash") >= 0.1 and not is_controller_dashed_pressed:
			is_controller_dashed_pressed = true
			dash_grace_timer.start()
		elif Input.get_action_strength("controller_dash") < 0.1:
			is_controller_dashed_pressed = false

func horizontal_movement(delta):
	if is_knocked_back:
		return
	if move_input:
		if abs(player.velocity.x) <= abs(current_move_speed):
			player.velocity.x = move_input * current_move_speed
		else:
			player.velocity.x = move_input * move_toward(abs(player.velocity.x), current_move_speed, 0.5 * delta * current_move_speed)
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, delta * H_DECELERATION * current_move_speed)

func dash_movement(_delta):
	if not dash_turn_around_timer.is_stopped(): #Grace period to change dash direction
		get_player_direction()
		dash_direction = direction_facing
	
	player.velocity.x = current_dash_speed * dash_direction
	player.velocity.y = 0
	
	if dash_attack_state:
		player.attack_control.check_end_dash()

func knockback_process(delta):
	#replace the normal velocity to one that's determind by knockback_vector
	#velocity = knockback_vector
	player.velocity.x = move_toward(player.velocity.x, 0, delta * 5 * current_move_speed)
	#subtract time from each frame until it become 0
	knockback_timer -= delta
	#gradually reduce knockback force -> Vector2.ZERO, delta * knockback_force * 2 is how fast it decays
	#knockback_vector = knockback_vector.move_toward(Vector2.ZERO, delta * knockback_force * 2)
	if knockback_timer <= 0:
		is_knocked_back = false
		player.velocity = Vector2.ZERO

func jump(_delta):
	if can_player_jump():
		air_jump_amount = MAX_AIR_JUMP_AMOUNT
		if is_jump_just_pressed():
			coyote_timer.stop()
			player.velocity.y = -JUMP_SPEED
	elif not air_jump_detector.is_colliding():
		if air_jump_amount > 0 and is_jump_just_pressed():
			air_jump_amount -= 1
			player.velocity.y = -JUMP_SPEED #* 0.8 #Reduce jump height of double jump
			#has_dash = true #DEBUG TEST GIVES YOU DASH AFTER JUMPING SECOND TIME
	
	if not player.is_on_floor() and Input.is_action_just_released("jump") and player.velocity.y < 0:
		player.velocity.y = lerp(player.velocity.y, 0.0, 0.8)


func is_jump_just_pressed():
	if not jump_grace_timer.is_stopped() and Input.is_action_pressed("jump"):
		jump_grace_timer.stop()
		return true
	return false

func is_dash_just_pressed():
	if not dash_grace_timer.is_stopped() and Input.is_action_pressed("dash"):
		dash_grace_timer.stop()
		return true
	return false

func can_player_jump():
	if player.is_on_floor():
		return true
	elif not coyote_timer.is_stopped():
		return true
	return false

func dash() -> void:
	has_dash = false
	dash_state = true
	dash_entry_speed = player.velocity.x
	current_dash_speed = DASH_SPEED
	player.velocity.y = 0
	dash_duration.start()
	
	get_player_direction()
	dash_direction = direction_facing
	dash_turn_around_timer.start()
	
	player.attack_control.try_dash_attack()

func continue_dash():
	has_dash = false
	dash_state = true
	current_dash_speed = DASH_SPEED #* 3
	player.velocity.y = 0
	dash_duration.start()
	#get_player_direction()
	#dash_direction = direction_facing
	
	player.attack_control.try_dash_attack()

func dash_attack() -> void:
	has_dash = false
	dash_state = false
	dash_attack_state = true
	current_dash_speed = DASH_SPEED * 3
	dash_direction = direction_facing
	player.velocity.y = 0
	player.health_control.apply_invincibility(0.2)
	player.fire_ball_active = true

func _on_dash_duration_timeout() -> void:
	if dash_state:
		dash_attack_cooldown.start()
		end_dash()
	
func end_dash():
	if is_knocked_back:
		return
	player.velocity.y = -JUMP_SPEED * 0.1
	player.velocity.x = dash_direction * dash_entry_speed#current_move_speed
	dash_state = false
	dash_attack_state = false
	player.health_control._on_invincibility_timer_timeout()

func end_dash_attack():
	if is_knocked_back:
		return
	has_dash = true
	air_jump_amount = MAX_AIR_JUMP_AMOUNT
	dash_state = false
	dash_attack_state = false
	dash_attack_cooldown.stop()
	
	if not player.attack_control.chain_dash_attack():
		player.velocity.y = -JUMP_SPEED * 0.3
		player.velocity.x = dash_direction * DASH_SPEED
		player.health_control._on_invincibility_timer_timeout()
		player.attack_control.reset_dash()
	#end_dash()

func apply_knockback(from_position: Vector2) -> void:
	is_knocked_back = true
	#knock player off the opposite direction
	var direction_sign = sign(player.global_position.x - from_position.x)
	direction_facing = -direction_sign
	var k_vector = Vector2(direction_sign * knockback_force, -knockback_upward_force)
	knockback_vector = k_vector
	player.velocity = knockback_vector
	#set timer
	knockback_timer = knockback_duration
	dash_state = false
	dash_attack_state = false

func apply_immobility(time_amount : float):
	immobile_timer.start(time_amount)
	dash_state = false
	dash_attack_state = false

func _input(event: InputEvent) -> void:
	if player.is_dead:
		return
	
	if event.is_action_pressed("jump"): # not dash_attack_state:
		jump_grace_timer.start()
	if event.is_action_pressed("dash"):
		dash_grace_timer.start()
	
	#if immobile_timer.is_stopped() and not is_knocked_back:
		#if event.is_action_pressed("jump"): # not dash_attack_state:
		#	jump_grace_timer.start()
	#	if event.is_action_pressed("dash"):
	#		dash_input()
		
func can_dash():
	return has_dash and not dash_state and dash_attack_cooldown.is_stopped()

func is_dashing():
	return dash_state or dash_attack_state
