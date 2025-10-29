extends Projectile
class_name ArcProjectile

var rng = RandomNumberGenerator.new()
var rand_speed : float

@export var GRAVITY = 300
#@export var target_x : float
#@export var arc_height : float

func _ready():
	#angle = atan2(-4*arc_height, target_x)
	#print(rad_to_deg(angle))
	#SPEED = sqrt((GRAVITY * (target_x**2 + 16*arc_height**2) / 8*arc_height)) / 60
	
	super._ready()
	
	#velocity.y = rng.randf_range(-300, -100)
	#SPEED = rng.randf_range(200, 300)

func _physics_process(delta: float) -> void:
	#velocity.x =  SPEED
	velocity.y += GRAVITY * delta
	move_and_slide()
