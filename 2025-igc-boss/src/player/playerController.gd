extends CharacterBody2D
class_name Player

@onready var move_control : PlayerMovement = $PlayerMovement
@onready var health_control : PlayerHealth = $PlayerHealth
@onready var attack_control : PlayerAttack= $PlayerAttack

@onready var flip_node = $flippable

@onready var animation_player = $AnimationPlayer
@onready var animated_sprite = $flippable/PlayerSprite
@onready var fireball_sprite = $flippable/FireBallSprite

@onready var ground_collision = $GroundCollision
@onready var air_collision = $AirCollision

@onready var ground_detector_right = $GroundDetectorRight
@onready var ground_detector_left = $GroundDetectorLeft
@onready var ground_detector_long_right = $GroundDetectorLongRight
@onready var ground_detector_long_left = $GroundDetectorLongLeft

@export var health_decay = true

var is_dead = false
var cause_of_death : String

var fire_ball_active = false

func _ready():
	#Engine.time_scale = 0.4
	add_to_group("player")
	fireball_sprite.modulate = Color(1,1,1,0)

func _physics_process(delta: float) -> void:
	if is_dead:
		ground_collision.disabled = false
		air_collision.disabled = false
	elif ground_detector_right.is_colliding() or ground_detector_left.is_colliding():
		var collision_length = 0
		if  ground_detector_right.is_colliding():
			collision_length = (ground_detector_right.target_position + global_position).distance_to(ground_detector_right.get_collision_point())
		if ground_detector_left.is_colliding():
			var left_collision_length = (ground_detector_left.global_position + global_position).distance_to(ground_detector_left.get_collision_point())
			if collision_length < left_collision_length:
				left_collision_length = collision_length
		#if collision_length < 20:
		position.y -= collision_length
		velocity.y = -10
		#else:
		#	print( clamp(-collision_length, -500, -50))
		#	velocity.y = clamp(-collision_length, -500, -50)
	elif ground_detector_long_right.is_colliding() or ground_detector_long_left.is_colliding():
		ground_collision.disabled = false
		air_collision.disabled = true
	else:
		ground_collision.disabled = true
		air_collision.disabled = false
	
	move_control.physics_update(delta)
	
	if fire_ball_active:
		if abs(velocity.x) > move_control.MOVE_SPEED:
			var alpha = (abs(velocity.x) - move_control.MOVE_SPEED) / (move_control.DASH_SPEED - move_control.MOVE_SPEED)
			alpha = clampf(2 * alpha, 0, 1)
			fireball_sprite.modulate = Color(1,1,1,alpha)
		else:
			fireball_sprite.modulate = Color(1,1,1,0)
			fire_ball_active = false
	
	debug_animation()

func _process(_delta: float) -> void:
	if not move_control.can_dash() and not move_control.is_dashing():
		flip_node.modulate = Color.GRAY
	else:
		flip_node.modulate = Color(1.164, 1.164, 1.164)
	#$DashIndicator.visible = move_control.can_dash()

func debug_animation():
	if move_control.is_dashing():
		flip_node.scale.x = move_control.dash_direction
	else:
		flip_node.scale.x = move_control.direction_facing
	
	if move_control.dash_attack_state:
		$ColorRect.color = Color.PURPLE
	elif move_control.dash_state:
		$ColorRect.color = Color.BLUE
	elif move_control.air_jump_amount == 1:
		$ColorRect.color = Color.GREEN
	elif move_control.air_jump_amount == 0:
		$ColorRect.color = Color.DARK_GREEN
	
	if is_dead:
		if cause_of_death == "Time":
			play_animation("time_death")
		else:
			play_animation("killed_death")
	elif move_control.is_knocked_back:
		play_animation("hit")
	elif move_control.dash_state or move_control.dash_attack_state:
		play_animation("dash")
	elif (ground_detector_right.is_colliding() or ground_detector_left.is_colliding() or is_on_floor()) and velocity.x != 0:
		play_animation("run")
	elif move_control.is_big_jump_peak():
		play_animation("jump2")
	elif velocity.y > 0:
		play_animation("fall")
	elif velocity.y < 0:
		play_animation("jump1")
	elif velocity.x == 0:
		play_animation("idle")
	else:
		play_animation("run")
		
func play_animation(anim_name : String):
	if animated_sprite.animation != anim_name:
		animated_sprite.play(anim_name)

func hit(attacker: Node2D) -> void:
	health_control.hit(attacker)

func super_hit(attacker : Node2D):
	print('super hit player')
	health_control.cancel_invincibility()
	move_control.end_dash()
	health_control.super_hit(attacker)

#func attack():
#	attack_control.attack()

func die(cause : String = "Attack"):
	if is_dead:
		return
	print("player died")
	cause_of_death = cause
	is_dead = true
	
	await animated_sprite.animation_finished
	
	queue_free()
	get_tree().reload_current_scene()

func hit_and_respawn(attacker : Node2D):
	health_control.hit(attacker)
	if is_dead:
		return
	await get_tree().create_timer(0.5).timeout
	velocity = Vector2.ZERO
	animation_player.play("Hit")
	health_control.apply_invincibility()
	move_control.apply_immobility(0.2)
	global_position = move_control.last_ground_location

func respawn():
	#or attacker.is_in_group("obstacles")
	velocity = Vector2.ZERO
	animation_player.play("Hit")
	move_control.apply_immobility(1)
	global_position = move_control.last_ground_location
	health_control.apply_invincibility()
	health_control.take_damage()

func _on_obstacle_collide(body: Node2D) -> void:
	if (body.is_in_group("obstacles") or body is TileMapLayer) and move_control.dash_attack_state:
		health_control.cancel_invincibility()
		move_control.end_dash()
	if body.is_in_group("obstacles"):
		hit_and_respawn(body)
	

func _on_enemy_collide(body: Node2D) -> void:
	if body is Enemy or body is Boss:
		if  not move_control.dash_state and not move_control.dash_attack_state:
			hit(body)

func killed_enemy(body: Node2D):
	#print('Enemy Slain')
	#if body is EnemyStatic:
	#	health_control.heal(5)
	#lse:
	health_control.heal(10)
	#move_control.dash()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("restart"):
		die()
