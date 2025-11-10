extends BossState
class_name MoveState

@export var boss : Boss

var target_location

func enter(direction):
	target_location = boss.global_position + direction * Vector2(100,0)

func physics_update(delta: float) -> void:
	var x_diff = target_location.x - boss.global_position.x
	var direction = sign(target_location.x - boss.global_position.x)
	var distance = abs(x_diff)
	
	if distance < 1:
		transition.emit("idleState")
	
	boss.velocity.y += boss.GRAVITY * delta
	boss.velocity.x = direction * boss.MOVE_SPEED
	boss.move_and_slide()
