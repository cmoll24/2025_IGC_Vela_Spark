class_name Enemy
extends CharacterBody2D

@export var GRAVITY : float = 1000.0

var projectile
@onready var level = get_tree().current_scene

var cooldown = 5.0

func _physics_process(delta: float) -> void:
	
	velocity.y += GRAVITY * delta
	move_and_slide()
	
	cooldown -= delta
	if cooldown <= 0:
		summon_projectile()
		cooldown = 5.0
	
	
func summon_projectile() -> void:
	var instance = projectile.instantiate()
	instance.spawnPos = global_position
	level.add_child(instance)
	
