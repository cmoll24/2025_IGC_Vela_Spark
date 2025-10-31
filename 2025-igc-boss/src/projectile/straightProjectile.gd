extends Projectile

@onready var hitArea = $Area2D


func _physics_process(_delta: float) -> void:
	#velocity = Vector2(SPEED, 0).rotated(angle)
	move_and_slide()
