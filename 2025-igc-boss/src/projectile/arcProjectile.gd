extends Projectile
class_name ArcProjectile

var rng = RandomNumberGenerator.new()
var rand_speed : float

@export var GRAVITY = 300

func _ready():
	super._ready()
	
	#velocity.y = rng.randf_range(-300, -100)
	#SPEED = rng.randf_range(200, 300)

func _physics_process(delta: float) -> void:
	velocity.y += GRAVITY * delta
	move_and_slide()
