extends Node
class_name PlayerHealth

@onready var invincibility_timer = $InvincibilityTimer

@export var player : Player
@export var hitbox : Area2D
@export var health_bar : ProgressBar

@export_category("Health variables")
@export var MAX_HEALTH := 50
var health : float = MAX_HEALTH
var healthBarSegments = 5

@export var INVINCIBILITY_DURATION : float = 1.0

signal enemy_collide(body : Node2D)
signal enemy_exit(body : Node2D)

func _ready() -> void:
	health_bar.max_value = MAX_HEALTH
	health_bar.value = health
	
	hitbox.body_entered.connect(_on_player_hitbox_body_entered)
	hitbox.body_exited.connect(_on_player_hitbox_body_exited)
	

func take_damage() -> void:
	#health - amount, 0 to make sure the health dont go under 0
	health = int(health) - (int(health) % 10)
	health_bar.value = health
	print("Player hit! Health:", health)
	if health <= 0:
		player.die()

func _process(delta):
	health = health - delta
	health_bar.value = health
	if health <= 0:
		player.die()
	
func _on_invincibility_timer_timeout() -> void:
	for body in hitbox.get_overlapping_bodies():
		_on_player_hitbox_body_entered(body)

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

func _on_player_hitbox_body_entered(body: Node2D) -> void:
	enemy_collide.emit(body)

func _on_player_hitbox_body_exited(body: Node2D) -> void:
	enemy_exit.emit(body)

func is_safe() -> bool:
	var danger_count = 0
	for x in hitbox.get_overlapping_bodies():
		if x is Enemy or x is Boss or x is Projectile:
			danger_count += 1
	return danger_count == 0

func heal(amount : float):
	#health = int(health) + (10 - int(health) % 10)
	health += amount
	health = min(health, MAX_HEALTH)

func full_heal():
	health = MAX_HEALTH
