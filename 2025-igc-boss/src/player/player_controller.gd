extends CharacterBody2D
#deez nuts
@onready var jump_grace_timer = $JumpGraceTime
@onready var coyote_timer = $CoyoteTime

@export_category("Movement variables")
@export var MOVE_SPEED : float = 400.0
@export var H_DECELERATION : float = 10
@export var GRAVITY : float = 1000.0
@export var MAX_FALL_SPEED : float = 50.0

@export_category("Jump variables")
@export var JUMP_SPEED : float = 700.0
@export var MAX_AIR_JUMP_AMOUNT : int = 1
var air_jump_amount : int = MAX_AIR_JUMP_AMOUNT
@export var JUMP_PEAK_RANGE : float = 20.0

var move_input = Vector2.ZERO
var current_gravity = GRAVITY
var current_move_speed = MOVE_SPEED

var is_touching_floor = false

func _physics_process(delta: float) -> void:
	if velocity.y < JUMP_PEAK_RANGE and velocity.y > -JUMP_PEAK_RANGE and not is_on_floor(): 
		current_gravity = GRAVITY / 2
	elif velocity.y > 0:
		current_gravity = GRAVITY * 2.5
	else:
		current_gravity = GRAVITY
	
	velocity.y += min(current_gravity * delta, MAX_FALL_SPEED)
	horizontal_movement(delta)
	jump(delta)
	
	debug_animation()
	
	move_and_slide()
	
	if is_on_floor():
		is_touching_floor = true
	elif is_touching_floor:
		is_touching_floor = false
		coyote_timer.start()
	
	$Debug_Label.text = "Gravity: {grav}".format({'grav' : current_gravity / 100})

func horizontal_movement(delta):
	move_input = Input.get_axis("move_left", "move_right")
	
	if move_input:
		velocity.x = move_input * current_move_speed
	else:
		velocity.x = move_toward(velocity.x, 0, delta * H_DECELERATION * current_move_speed)

func jump(_delta):
	if can_player_jump():
		air_jump_amount = MAX_AIR_JUMP_AMOUNT
		if is_jump_just_pressed():
			coyote_timer.stop()
			velocity.y = -JUMP_SPEED
	
	else:
		if air_jump_amount > 0:
			if is_jump_just_pressed():
				air_jump_amount -= 1
				velocity.y = -JUMP_SPEED * 0.8
			
	if not is_on_floor() and Input.is_action_just_released("jump") and velocity.y < 0: #add extra gravity
		#velocity.y = 0
		velocity.y = lerp(velocity.y, 0.0, 0.8)
		#velocity.y = lerp(velocity.y, GRAVITY, 0.2)
		#velocity.y *= 0.3

func debug_animation():
	if air_jump_amount == 1:
		$ColorRect.color = Color.GREEN
	elif air_jump_amount == 0:
		$ColorRect.color = Color.DARK_GREEN

func is_jump_just_pressed():
	if not jump_grace_timer.is_stopped():
		jump_grace_timer.stop()
		return true
	return false

func can_player_jump():
	if is_on_floor():
		return true
	elif not coyote_timer.is_stopped():
		return true
	return false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		jump_grace_timer.start()
