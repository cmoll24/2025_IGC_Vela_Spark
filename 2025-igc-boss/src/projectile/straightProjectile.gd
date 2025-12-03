extends Projectile
class_name StraightProjectile

@onready var hitArea = $rotatable/Area2D


func _physics_process(_delta: float) -> void:
	#velocity = Vector2(SPEED, 0).rotated(angle)
	move_and_slide()
