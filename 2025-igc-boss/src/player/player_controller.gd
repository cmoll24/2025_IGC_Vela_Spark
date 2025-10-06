extends CharacterBody2D

@export_category("Movement variables")
@export var MOVE_SPEED = 500.0
@export var H_DECELERATION = 10
@export var GRAVITY = 1000.0

@export_category("Jump variables")
@export var JUMP_SPEED = 900.0
@export var MAX_JUMP_AMOUNT = 2
var jump_amount = MAX_JUMP_AMOUNT

var move_input = Vector2.ZERO

func _physics_process(delta: float) -> void:
	velocity.y += GRAVITY * delta
	horizontal_movement(delta)
	jump(delta)
	
	move_and_slide()

func horizontal_movement(delta):
	move_input = Input.get_axis("move_left", "move_right")
	
	if move_input:
		velocity.x = move_input * MOVE_SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, delta * H_DECELERATION * MOVE_SPEED)

func jump(_delta):
	if is_on_floor():
		jump_amount = MAX_JUMP_AMOUNT
		
	if Input.is_action_just_pressed("jump") and jump_amount > 0:
		jump_amount -= 1
		velocity.y = -JUMP_SPEED
	
	if not is_on_floor():
		if Input.is_action_just_released("jump") and velocity.y < 0: #add extra gravity
			velocity.y = lerp(velocity.y, GRAVITY, 0.2)
			velocity.y *= 0.3
