extends Projectile

func _ready():
	#global_position = Vector2(599, 397)
	#global_rotation = spawnRot
	#self.add_to_group("projectiles")
	velocity.y = -150

func _physics_process(delta: float) -> void:
	velocity.x = SPEED
	velocity.y += 100 * delta
	move_and_slide()


func _on_area_2d_body_entered(body: Node2D) -> void:
	print(body.name)
	if not body.is_in_group("projectiles"):
		print(body.name)
		queue_free()
