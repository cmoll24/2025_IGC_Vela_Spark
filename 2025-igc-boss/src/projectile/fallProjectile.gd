extends Projectile

var rng = RandomNumberGenerator.new()
var randx : float

func _ready():
	global_position = spawnPos
	global_rotation = spawnRot
	self.add_to_group("projectiles")
	randx = rng.randf_range(-20.0, 20.0)
	
	velocity.y = 200
	
func _physics_process(delta: float) -> void:
	velocity.x = randx
	velocity.y += 100 * delta
	move_and_slide()
