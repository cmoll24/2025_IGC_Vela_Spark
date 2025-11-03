extends Enemy
class_name EnemyGrounded

func _physics_process(delta: float) -> void:
	velocity.y += GRAVITY * delta
	super._physics_process(delta)
