extends BossState
class_name IdleState

@export var boss : Boss

var idle_duration

func enter(_arg):
	idle_duration = 0.1

func physics_update(delta: float) -> void:
	idle_duration -= delta
	
	if idle_duration < 0:
		transition.emit("AimAttack")
	
	boss.velocity.y += boss.GRAVITY * delta
	boss.velocity.x = move_toward(boss.velocity.x, 0, delta * boss.H_DECELERATION * boss.MOVE_SPEED)
	boss.move_and_slide()
