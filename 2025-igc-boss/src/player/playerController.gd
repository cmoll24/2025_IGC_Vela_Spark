extends CharacterBody2D
class_name Player

@onready var move_control = $PlayerMovement
@onready var health_control = $PlayerHealth

@onready var animation_player = $AnimationPlayer

func _ready():
	add_to_group("player")

func _physics_process(delta: float) -> void:
	move_control.physics_update(delta)
	
	debug_animation()

func debug_animation():
	if move_control.dash_attack_state:
		$ColorRect.color = Color.ORANGE_RED
	elif move_control.dash_state:
		$ColorRect.color = Color.ORANGE
	elif move_control.air_jump_amount == 1:
		$ColorRect.color = Color.GREEN
	elif move_control.air_jump_amount == 0:
		$ColorRect.color = Color.DARK_GREEN

func hit(attacker: Node2D) -> void:
	health_control.hit(attacker)

func die():
	print("player died")
	get_tree().reload_current_scene()

func respawn():
	#or attacker.is_in_group("obstacles")
	$AnimationPlayer.play("Hit")
	global_position = move_control.last_ground_location
	health_control.apply_invincibility()
	health_control.take_damage(10)


func _on_enemy_collide(body: Node2D) -> void:
	if body is Enemy or body is Boss:
		if move_control.dash_state:
			move_control.dash_attack()
			#velocity.x = -dash_direction * current_move_speed
			#dash_state = false
			#dash_attack_state = false
			#apply_knockback(body.global_position)
			#apply_invincibility()
		elif not move_control.dash_attack_state:
			hit(body)
	if (body.is_in_group("obstacles") or body is TileMapLayer) and move_control.dash_attack_state:
		move_control.end_dash()


func _on_enemy_exit(body: Node2D) -> void:
	if move_control.dash_attack_state and (body is Enemy or body is Boss):
		move_control.end_dash_attack()
