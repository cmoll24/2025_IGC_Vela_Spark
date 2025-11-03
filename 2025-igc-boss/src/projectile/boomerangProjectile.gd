extends Projectile
class_name BoomerangProjectile

@export var TIME_UNTIL_SWITCH = 1
@export var FREEZE_TIME = 0

var has_frozen = false
var switch_direction_timer : float = 0
var freeze_timer : float = 0
var starting_velocity : Vector2

func _ready():
	super._ready()
	
	switch_direction_timer = TIME_UNTIL_SWITCH
	starting_velocity = velocity

func _physics_process(delta: float) -> void:
	switch_direction_timer -= delta
	freeze_timer -= delta
	
	if not has_frozen and velocity.length_squared() < 50 and switch_direction_timer < 0:
		freeze_timer = FREEZE_TIME
		has_frozen = true
	
	if freeze_timer < 0:
		if switch_direction_timer < 0:
			velocity = velocity.lerp(-starting_velocity, delta)
		move_and_slide()
