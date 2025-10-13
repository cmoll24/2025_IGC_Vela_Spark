extends CharacterBody2D

@onready var jump_grace_timer = $JumpGraceTime
@onready var coyote_timer = $CoyoteTime
@onready var dash_attack_cooldown = $DashAttackCooldown
@onready var dash_duration = $DashDuration


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

var has_dash = true
var dash_attack_state = false
@export_category("Knockback variables")
@export var knockback_force: float = 1000.0
@export var knockback_upward_force: float = 250.0
@export var knockback_duration: float = 0.2

var knockback_vector: Vector2 = Vector2.ZERO
var is_knocked_back: bool = false
var knockback_timer: float = 0.0

var move_input = Vector2.ZERO
var current_gravity = GRAVITY
var current_move_speed = MOVE_SPEED
var is_touching_floor = false

#for health 
@onready var health_bar = $ProgressBar
@export var max_health := 100
var health: int = 100
var current_health = max_health


func _ready():
	add_to_group("player")
	health_bar.max_value = max_health
	health_bar.value = current_health


func _physics_process(delta: float) -> void:
	if velocity.y < JUMP_PEAK_RANGE and velocity.y > -JUMP_PEAK_RANGE and not is_on_floor(): 
		current_gravity = GRAVITY / 2
	elif velocity.y > 0:
		current_gravity = GRAVITY * 2.5
	else:
		current_gravity = GRAVITY
	
	#Movement States
	if is_knocked_back:
		knockback_process(delta)
	else:
		if dash_attack_state:
			dash_movement(delta)
		else:
			velocity.y += current_gravity * delta
			horizontal_movement(delta)
		jump(delta)
	
	if is_touching_floor:
		has_dash = true
	
	debug_animation()
	
	move_and_slide()

	if is_on_floor():
		is_touching_floor = true
	elif is_touching_floor:
		is_touching_floor = false
		coyote_timer.start()
	
	$Debug_Label.text = "Gravity: {grav}".format({'grav' : current_gravity / 100})

func horizontal_movement(delta):
	if is_knocked_back:
		return
	move_input = Input.get_axis("move_left", "move_right")
	if move_input:
		velocity.x = move_input * current_move_speed
	else:
		velocity.x = move_toward(velocity.x, 0, delta * H_DECELERATION * current_move_speed)

func dash_movement(_delta):
	move_input = Input.get_axis("move_left", "move_right")
	velocity.x = 1250 * move_input
func knockback_process(delta):
	#replace the normal velocity to one that's determind by knockback_vector
	velocity = knockback_vector
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
			velocity.y = -JUMP_SPEED
	else:
		if air_jump_amount > 0 and is_jump_just_pressed():
			air_jump_amount -= 1
			velocity.y = -JUMP_SPEED * 0.8
	
	if not is_on_floor() and Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y = lerp(velocity.y, 0.0, 0.8)

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
	elif event.is_action_pressed("dash"):
		if has_dash and dash_attack_cooldown.is_stopped():
			dash_attack()
			
func dash_attack() -> void:
	has_dash = false
	dash_attack_state = true
	dash_attack_cooldown.start()
	velocity.y = 0
	dash_duration.start()

func _on_dash_duration_timeout() -> void:
	velocity.y = -JUMP_SPEED * 0.1
	dash_attack_state = false
		
func take_damage(amount: int) -> void:
	#current_health - amount, 0 to make sure the health dont go under 0
	current_health = max(current_health - amount, 0)
	health_bar.value = current_health
	print("Player hit! Health:", current_health)

	if current_health <= 0:
		die()

func apply_knockback(from_position: Vector2) -> void:
	#knock player off the opposite direction
	var direction_sign = sign(global_position.x - from_position.x)
	var k_vector = Vector2(direction_sign * knockback_force, -knockback_upward_force)
	knockback_vector = k_vector
	#set timer
	is_knocked_back = true
	knockback_timer = knockback_duration

		
func die():
	print("player died")
	get_tree().reload_current_scene()

func _on_player_hitbox_area_entered(area: Area2D) -> void:
	if area.name == "enemy_hitbox":
		take_damage(10)
		apply_knockback(area.global_position)
		print("hit!")
