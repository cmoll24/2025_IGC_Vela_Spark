extends Projectile

@onready var hitArea = $projectile_area2d


func _physics_process(_delta: float) -> void:
	velocity = Vector2(SPEED, 0).rotated(direction)
	move_and_slide()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if not body.is_in_group("projectiles"):
		if body.name == "player_hitbox" or body.is_in_group("player"):
			print("hit player")
		queue_free()
