extends Node
class_name PlayerHealth

@onready var invincibility_timer = $InvincibilityTimer

@export var player : Player
@export var hitbox : Area2D
@export var danger_detector : Area2D

@export_category("Health variables")
@export var MAX_HEALTH := 70
var health : float = MAX_HEALTH

@export var INVINCIBILITY_DURATION : float = 1.0
@export var DECAY_COEF := 1.4

signal enemy_collide(body : Node2D)
signal obstacle_collide(body : Node2D)

func _ready() -> void:
	hitbox.area_entered.connect(_on_player_hitbox_area_entered)
	hitbox.body_entered.connect(_on_player_hitbox_body_entered)
	

func take_damage() -> void:
	#health - amount, 0 to make sure the health dont go under 0
	health -= 10 #int(health) - (int(health) % 10)
	print("Player hit! Health:", health)
	if health <= 0:
		player.die()

func _process(delta):
	if player.health_decay:
		health = health - DECAY_COEF * delta
		if health <= 0:
			player.die("Time")
	
func _on_invincibility_timer_timeout() -> void:
	for area in hitbox.get_overlapping_areas():
		_on_player_hitbox_area_entered(area)

func apply_invincibility(new_invincibility_time = INVINCIBILITY_DURATION):
	invincibility_timer.start(new_invincibility_time)

func cancel_invincibility():
	invincibility_timer.stop()

func hit(attacker: Node2D) -> void:
	if invincibility_timer.is_stopped():
		player.animation_player.play("Hit")
		take_damage()
		apply_invincibility()
		player.move_control.apply_knockback(attacker.global_position)
		print("hit!")

func super_hit(attacker : Node2D):
	player.animation_player.play("Hit")
	take_damage()
	apply_invincibility()
	player.move_control.apply_knockback(attacker.global_position)
	print("hit!")

func _on_player_hitbox_area_entered(area : Area2D) -> void:
	var parent_body = area.get_parent()
	if parent_body is Node2D:
		enemy_collide.emit(parent_body)

func _on_player_hitbox_body_entered(body : Node2D) -> void:
	obstacle_collide.emit(body)

func is_safe() -> bool:
	var danger_count = 0
	for x in danger_detector.get_overlapping_bodies():
		if x is Enemy or x is Boss or x is Projectile or x.is_in_group("obstacles"):
			danger_count += 1
	return danger_count == 0

func heal(amount : float):
	#health = int(health) + (10 - int(health) % 10)
	health += amount
	health = min(health, MAX_HEALTH)

func full_heal():
	health = MAX_HEALTH
