extends Projectile

var rng = RandomNumberGenerator.new()
var randx : float

func _ready():
	global_position = spawnPos
	global_rotation = spawnRot
	self.add_to_group("projectiles")
	randx = rng.randf_range(-50.0, 50.0)
	
func _physics_process(delta: float) -> void:
	velocity.x = randx
	velocity.y += 100 * delta
	move_and_slide()
	

func _on_area_2d_body_entered(body: Node2D) -> void:
	if not body.is_in_group("projectiles"):
		queue_free()
