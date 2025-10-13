class_name Enemy
extends CharacterBody2D

@export var GRAVITY : float = 1000.0
@export var move_time : float = 3.0
@export var speed : float = 200.0
@export var activation_delay: float = 0.1

var direction = -1
var timer = 0.0
var active = false

func _physics_process(delta: float) -> void:
	velocity.y += GRAVITY * delta
	move_and_slide()
	

func _process(delta: float) -> void:
	#going left and right
	position.x += direction * speed * delta
	timer += delta
	if timer >= move_time:
		direction *= -1
		timer = 0.0
