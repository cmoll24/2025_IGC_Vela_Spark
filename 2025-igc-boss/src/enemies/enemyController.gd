class_name Enemy
extends CharacterBody2D

@onready var enemy_death_sound = load("res://src/enemies/EnemyDeathSound.tscn")

@export var GRAVITY : float = 1000.0
@export var move_time : float = 3.0
@export var speed : float = 200.0
@export var activation_delay: float = 0.1
@export var MAX_HEALTH : int = 1
@export var direction : int = -1

@export var deathColor = Color(0.6,0.5,0.5)

@export var is_respawnable = false
@export var RESPAWN_TIME : float = 3
var is_dead = false
var respawn_timer : float = RESPAWN_TIME
var repsawn_pos : Vector2
var hide_pos = Vector2(-10_000, -10_000)

var timer = 0.0
var active = false

var health = MAX_HEALTH

var projectile

var invulnerable = false

#var cooldown = 5.0

var is_ridding = false

func _ready() -> void:
	pass

func _physics_process(_delta: float) -> void:
	if not is_ridding:
		move_and_slide()
	

func _process(delta: float) -> void:
	if is_dead:
		respawn_timer -= delta
		if respawn_timer < 0:
			respawn()
			
#	#going left and right
#	position.x += direction * speed * delta
#	timer += delta
#	if timer >= move_time:
#		direction *= -1
#		timer = 0.0
#	cooldown -= delta
#	if cooldown <= 0:
#		summon_projectile()
#		cooldown = 5.0

func collide(body: Node2D) -> void:
	if body.is_in_group("obstacles"):
		take_damage(MAX_HEALTH)
	#if body is Player:
	#	body.damage(self)

func take_damage(amount: int) -> void:
	health = max(health - amount, 0)

	if health <= 0:
		die()

func hit(attacker: Player) -> void:
	take_damage(1)
	
	if health <= 0:
		attacker.killed_enemy(self)

func respawn():
	is_dead = false
	respawn_timer = RESPAWN_TIME
	global_position = repsawn_pos
	health = MAX_HEALTH

func die():
	if is_ridding:
		get_parent().kill_projectile()
	if is_respawnable:
		play_death_sound()
		is_dead = true
		repsawn_pos = global_position
		global_position = hide_pos
	else:
		play_death_sound()
		queue_free()

func play_death_sound():
	var death_sound : AudioStreamPlayer2D = enemy_death_sound.instantiate()
	Global.get_game_scene().current_level.add_child(death_sound)
	death_sound.global_position = self.global_position

func brighten(brightened_color):
	modulate = brightened_color

func unbrighten():
	modulate = Color.WHITE
