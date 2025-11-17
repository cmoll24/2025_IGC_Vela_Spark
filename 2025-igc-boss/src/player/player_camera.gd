extends Camera2D

@export var player : Player

@export var move_speed = 2

func _process(delta: float) -> void:
	var target_offset : Vector2 = Vector2.ZERO
	move_speed = 10
	
	if player.velocity.y > 400:
		move_speed = 2
		target_offset = Vector2(0, clampf(player.velocity.y,0,600))
	elif Input.is_action_pressed("look_down"):
		move_speed = 10
		target_offset = Vector2(0, 400)
	#elif  player.velocity.y < -100:
	#	target_offset = Vector2(0, -400)
		
	position = lerp(position, target_offset, move_speed * delta)
