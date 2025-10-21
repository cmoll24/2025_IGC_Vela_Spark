extends Node
class_name PlayerMovement

@onready var jump_grace_timer = $JumpGraceTime
@onready var coyote_timer = $CoyoteTime
@onready var dash_attack_cooldown = $DashAttackCooldown
@onready var dash_duration = $DashDuration
@onready var ground_detector = $GroundDetector

@export var player : Player

@export var debug_label : Label

@export_category("Movement variables")
@export var MOVE_SPEED : float = 500.0
@export var H_DECELERATION : float = 10
@export var GRAVITY : float = 1100.0
@export var MAX_FALL_SPEED : float = 1200.0

@export_category("Jump variables")
@export var JUMP_SPEED : float = 750.0
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

@export_category("Knockback variables")
@export var knockback_force: float = 1000.0
@export var knockback_upward_force: float = 400.0
@export var knockback_duration: float = 0.5

var knockback_vector: Vector2 = Vector2.ZERO
var is_knocked_back: bool = false
var knockback_timer: float = 0.0

var move_input = Vector2.ZERO
var current_gravity = GRAVITY
var current_move_speed = MOVE_SPEED
var is_touching_floor = false

var direction_facing = 1

var last_ground_location : Vector2

func get_player_direction():
	move_input = Input.get_axis("move_left", "move_right")
	if move_input != 0:
		direction_facing = sign(move_input)

func physics_update(delta: float) -> void:
	if player.velocity.y < JUMP_PEAK_RANGE and player.velocity.y > -JUMP_PEAK_RANGE and not player.is_on_floor(): 
		current_gravity = GRAVITY / 2
	elif player.velocity.y > 0:
		current_gravity = GRAVITY * 2.5
	else:
		current_gravity = GRAVITY
	
	#Movement States
	get_player_direction()
	
	if is_knocked_back:
		player.velocity.y += GRAVITY * delta
		knockback_process(delta)
	else:
		if dash_state or dash_attack_state:
			dash_movement(delta)
		else:
			player.velocity.y += current_gravity * delta
			horizontal_movement(delta)
			jump(delta)
	
	if is_touching_floor:
		has_dash = true
	
	player.velocity.y = min(player.velocity.y, MAX_FALL_SPEED)
	debug_label.text = str(player.velocity.round())
	player.move_and_slide()

	if player.is_on_floor():
		is_touching_floor = true
	elif is_touching_floor:
		is_touching_floor = false
		coyote_timer.start()
		
	if ground_detector.is_colliding():
		player.last_ground_location = player.global_position
	
	#$Debug_Label.text = "Gravity: {grav}".format({'grav' : current_gravity / 100})

func horizontal_movement(delta):
	if is_knocked_back:
		return
	if move_input:
		player.velocity.x = move_input * current_move_speed
	else:
		player.velocity.x = move_toward(player.velocity.x, 0, delta * H_DECELERATION * current_move_speed)

func dash_movement(_delta):
	player.velocity.x = current_dash_speed * dash_direction
	player.velocity.y = 0

func knockback_process(delta):
	#replace the normal velocity to one that's determind by knockback_vector
	#velocity = knockback_vector
	player.velocity.x = move_toward(player.velocity.x, 0, delta * 5 * current_move_speed)
	#subtract time from each frame until it become 0
	knockback_timer -= delta
	#gradually reduce knockback force -> Vector2.ZERO, delta * knockback_force * 2 is how fast it decays
	knockback_vector = knockback_vector.move_toward(Vector2.ZERO, delta * knockback_force * 2)
	if knockback_timer <= 0:
		is_knocked_back = false

func jump(_delta):
	if can_player_jump():
		air_jump_amount = MAX_AIR_JUMP_AMOUNT
		if is_jump_just_pressed():
			coyote_timer.stop()
			player.velocity.y = -JUMP_SPEED
	else:
		if air_jump_amount > 0 and is_jump_just_pressed():
			air_jump_amount -= 1
			player.velocity.y = -JUMP_SPEED #* 0.8 #Reduce jump height of double jump
	
	if not player.is_on_floor() and Input.is_action_just_released("jump") and player.velocity.y < 0:
		player.velocity.y = lerp(player.velocity.y, 0.0, 0.8)


func is_jump_just_pressed():
	if not jump_grace_timer.is_stopped():
		jump_grace_timer.stop()
		return true
	return false

func can_player_jump():
	if player.is_on_floor():
		return true
	elif not coyote_timer.is_stopped():
		return true
	return false

func dash() -> void:
	get_player_direction()
	has_dash = false
	dash_state = true
	current_dash_speed = DASH_SPEED
	dash_direction = direction_facing
	player.velocity.y = 0
	dash_duration.start()

func dash_attack() -> void:
	has_dash = false
	dash_state = false
	dash_attack_state = true
	current_dash_speed = DASH_SPEED * 2
	dash_direction = direction_facing
	player.velocity.y = 0

func _on_dash_duration_timeout() -> void:
	if dash_state:
		dash_attack_cooldown.start()
		end_dash()
	
func end_dash():
	player.velocity.y = -JUMP_SPEED * 0.1
	player.velocity.x = dash_direction * current_move_speed
	dash_state = false
	dash_attack_state = false
	player.health_control._on_invincibility_timer_timeout()

func end_dash_attack():
	has_dash = true
	air_jump_amount = MAX_AIR_JUMP_AMOUNT
	end_dash()

func apply_knockback(from_position: Vector2) -> void:
	#knock player off the opposite direction
	var direction_sign = sign(player.global_position.x - from_position.x)
	var k_vector = Vector2(direction_sign * knockback_force, -knockback_upward_force)
	knockback_vector = k_vector
	player.velocity = knockback_vector
	#set timer
	is_knocked_back = true
	knockback_timer = knockback_duration

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("jump") and not dash_attack_state:
		jump_grace_timer.start()
	elif event.is_action_pressed("dash"):
		if has_dash and dash_attack_cooldown.is_stopped():
			dash()
