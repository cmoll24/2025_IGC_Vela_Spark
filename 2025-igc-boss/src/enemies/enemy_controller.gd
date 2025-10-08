class_name Enemy
extends CharacterBody2D

@export var GRAVITY : float = 1000.0

func _physics_process(delta: float) -> void:
	
	velocity.y += GRAVITY * delta
	
	move_and_slide()
