extends Projectile

var rng = RandomNumberGenerator.new()
var randx : float

func _ready():
	SPEED = 0
	super._ready()
	#randx = rng.randf_range(-20.0, 20.0)
	#velocity.y = 200
	
func _physics_process(delta: float) -> void:
	#velocity.x = randx
	velocity.y += 100 * delta
	velocity.y = min(velocity.y, MAX_FALL_SPEED)
	move_and_slide()
