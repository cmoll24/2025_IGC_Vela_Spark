extends Projectile

var rng = RandomNumberGenerator.new()
var rand_speed : float

func _ready():
	global_position = spawnPos
	global_rotation = spawnRot
	self.add_to_group("projectiles")
	velocity.y = rng.randf_range(-300, -100)
	SPEED = rng.randf_range(200, 300)

func _physics_process(delta: float) -> void:
	velocity.x = SPEED
	velocity.y += 200 * delta
	move_and_slide()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if not body.is_in_group("projectiles"):
		queue_free()
