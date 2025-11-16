extends BossState
class_name ChargeState

@export var boss : Boss

var last_position : Vector2
var target_location

func enter(_arg):
	var direction_to_player_x = sign(boss.global_position.direction_to(boss.player.global_position).x)
	target_location = boss.global_position + direction_to_player_x * Vector2(700,0)

func physics_update(delta: float) -> void:
	var direction_x = sign(boss.global_position.direction_to(target_location).x)
	
	if abs(boss.global_position.x - target_location.x) < 10 \
	or abs(boss.global_position.x - last_position.x) < 10:
		transition.emit("straightAttack")
	
	last_position = boss.global_position
	
	boss.velocity.y += boss.GRAVITY * delta
	boss.velocity.x = direction_x * boss.MOVE_SPEED * 7
	boss.move_and_slide()

func exit():
	boss.face_player()
	boss.velocity.x = 0
