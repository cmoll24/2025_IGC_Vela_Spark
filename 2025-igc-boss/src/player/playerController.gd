extends CharacterBody2D
class_name Player

@onready var move_control : PlayerMovement = $PlayerMovement
@onready var health_control : PlayerHealth = $PlayerHealth
@onready var attack_control : PlayerAttack= $PlayerAttack

@onready var flip_node = $flippable

@onready var animation_player = $AnimationPlayer
@onready var animated_sprite = $flippable/PlayerSprite

@onready var ground_collision = $GroundCollision
@onready var air_collision = $AirCollision

@onready var ground_detector_right = $GroundDetectorRight
@onready var ground_detector_left = $GroundDetectorLeft
@onready var ground_detector_long_right = $GroundDetectorLongRight
@onready var ground_detector_long_left = $GroundDetectorLongLeft

var is_dead = false

func _ready():
	add_to_group("player")

func _physics_process(delta: float) -> void:
	if ground_detector_right.is_colliding() or ground_detector_left.is_colliding():
		var collision_length = min(ground_detector_right.global_position.distance_to(ground_detector_right.get_collision_point()),
									ground_detector_left.global_position.distance_to(ground_detector_left.get_collision_point()),)
		velocity.y = clamp(-10_000/collision_length, -500, -50)
	elif ground_detector_long_right.is_colliding() and ground_detector_long_left.is_colliding():
		ground_collision.disabled = false
		air_collision.disabled = true
	else:
		ground_collision.disabled = true
		air_collision.disabled = false
	
	move_control.physics_update(delta)
	
	debug_animation()

func _process(_delta: float) -> void:
	$DashIndicator.visible = move_control.can_dash()

func debug_animation():
	flip_node.scale.x = move_control.direction_facing
	
	if move_control.dash_attack_state:
		$ColorRect.color = Color.PURPLE
	elif move_control.dash_state:
		$ColorRect.color = Color.BLUE
	elif move_control.air_jump_amount == 1:
		$ColorRect.color = Color.GREEN
	elif move_control.air_jump_amount == 0:
		$ColorRect.color = Color.DARK_GREEN
	
	if move_control.is_knocked_back:
		animated_sprite.play("hit")
	elif move_control.is_big_jump_peak():
		animated_sprite.play("jump2")
	elif velocity.y > 0:
		animated_sprite.play("fall")
	elif velocity.y < 0:
		animated_sprite.play("jump1")
	elif velocity.x == 0:
		animated_sprite.play("idle")
	else:
		animated_sprite.play("idle")
		

func hit(attacker: Node2D) -> void:
	health_control.hit(attacker)

#func attack():
#	attack_control.attack()

func die():
	print("player died")
	is_dead = true
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


func _on_enemy_collide(body: Node2D) -> void:
	if (body.is_in_group("obstacles") or body is TileMapLayer) and move_control.dash_attack_state:
		health_control.cancel_invincibility()
		move_control.end_dash()
	if body is Enemy or body is Boss:
		if  not move_control.dash_state and not move_control.dash_attack_state:
			hit(body)
	if body.is_in_group("obstacles"):
		hit_and_respawn(body)


func _on_enemy_exit(_body: Node2D) -> void:
	pass
	#if move_control.dash_attack_state and (body is Enemy or body is Boss):
	#	move_control.end_dash_attack()
		#else:
		#	move_control.dash()

func killed_enemy(_body: Node2D):
	#print('Enemy Slain')
	health_control.heal(10)
	#move_control.dash()
