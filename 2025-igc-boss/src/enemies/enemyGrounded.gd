extends Enemy
class_name EnemyGrounded

func _physics_process(delta: float) -> void:
	velocity.y += GRAVITY * delta
	move_and_slide()
