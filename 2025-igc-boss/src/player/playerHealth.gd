extends Node
class_name PlayerHealth

@onready var invincibility_timer = $InvincibilityTimer

@export var player : Player
@export var hitbox : Area2D
@export var health_bar : ProgressBar

@export_category("Health variables")
@export var MAX_HEALTH := 50
var health: int = 50
var current_health = MAX_HEALTH
var healthBarSegments = 5

@export var INVINCIBILITY_DURATION : float = 1.0

signal enemy_collide(body : Node2D)
signal enemy_exit(body : Node2D)

func _ready() -> void:
	health_bar.max_value = MAX_HEALTH
	health_bar.value = current_health
	
	hitbox.body_entered.connect(_on_player_hitbox_body_entered)
	hitbox.body_exited.connect(_on_player_hitbox_body_exited)

func take_damage(amount: int) -> void:
	#current_health - amount, 0 to make sure the health dont go under 0
	current_health = max(current_health - amount, 0)
	health_bar.value = current_health
	print("Player hit! Health:", current_health)
	if hitbox.body_entered.connect(_on_player_hitbox_body_entered):	
		if current_health <= 20 and current_health > 10:
			current_health = 10
			health_bar.value = current_health
		if current_health <= 30 and current_health > 20:
			current_health = 20
			health_bar.value = current_health
		if current_health <= 40 and current_health > 30:
			current_health = 30
			health_bar.value = current_health
		if current_health <= 50 and current_health > 40:
			current_health = 40
			health_bar.value = current_health
	if current_health <= 0:
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
		take_damage(10)
		apply_invincibility()
		player.move_control.apply_knockback(attacker.global_position)
		print("hit!")

func _on_player_hitbox_body_entered(body: Node2D) -> void:
	enemy_collide.emit(body)

func _on_player_hitbox_body_exited(body: Node2D) -> void:
	enemy_exit.emit(body)
