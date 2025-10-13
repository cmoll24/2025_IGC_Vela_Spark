extends BossState
class_name MoveState

@export var boss : Boss

var target_location

func enter(_arg):
	target_location = boss.global_position + Vector2(50,0)

func physics_update(delta: float) -> void:
	var direction = boss.global_position.direction_to(target_location)
	
	if boss.global_position.distance_squared_to(target_location) < 1:
		transition.emit("idleState")
	
	boss.velocity.y += boss.GRAVITY * delta
	boss.velocity.x = direction.x * boss.MOVE_SPEED
	boss.move_and_slide()
