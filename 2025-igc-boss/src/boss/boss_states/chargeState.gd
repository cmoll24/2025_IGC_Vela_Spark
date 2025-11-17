extends BossState
class_name ChargeState

@export var boss : Boss

var last_position : Vector2
var target_location

func enter(_arg):
	boss.face_player()
	var direction_to_player_x = -sign(boss.facing_direction)
	target_location = boss.global_position + direction_to_player_x * Vector2(400,0)
	boss.play_animation("walk")

func physics_update(delta: float) -> void:
	var direction_x = sign(boss.global_position.direction_to(target_location).x)
	
	if abs(boss.global_position.x - target_location.x) < 10 \
	or abs(boss.global_position.x - last_position.x) < 2:
		transition.emit("straightAttack")
	
	last_position = boss.global_position
	
	boss.velocity.y += boss.GRAVITY * delta
	boss.velocity.x = direction_x * boss.MOVE_SPEED * 6
	boss.move_and_slide()

func exit():
	boss.play_animation("idle")
	boss.face_player()
	boss.velocity.x = 0
