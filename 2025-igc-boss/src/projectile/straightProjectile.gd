extends "res://src/projectile/baseProjectile.gd"

@onready var hitArea = $Area2D


func _physics_process(delta: float) -> void:
	velocity = Vector2(SPEED, 0).rotated(direction)
	move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	print("Hello")
