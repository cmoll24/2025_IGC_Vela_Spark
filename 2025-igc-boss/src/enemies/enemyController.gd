class_name Enemy
extends CharacterBody2D

@export var GRAVITY : float = 1000.0
@export var move_time : float = 3.0
@export var speed : float = 200.0
@export var activation_delay: float = 0.1

var direction = -1
var timer = 0.0
var active = false

var health = 1

var projectile
@onready var level = get_tree().current_scene

var cooldown = 5.0

func _physics_process(delta: float) -> void:
	velocity.y += GRAVITY * delta
	move_and_slide()
	

#func _process(delta: float) -> void:
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
	
	
func summon_projectile() -> void:
	var instance = projectile.instantiate()
	instance.spawnPos = global_position
	level.add_child(instance)


func collide(_body: Node2D) -> void:
	pass
	#if body is Player:
	#	body.damage(self)

func take_damage(amount: int) -> void:
	health = max(health - amount, 0)

	if health <= 0:
		die()

func hit(attacker: Node2D) -> void:
	take_damage(1)
	
	if health <= 0:
		attacker.killed_enemy(self)

func die():
	queue_free()
