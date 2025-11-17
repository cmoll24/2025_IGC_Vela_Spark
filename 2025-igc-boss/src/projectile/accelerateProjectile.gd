extends Projectile
class_name AccelerateProjectile

@onready var hitArea = $Area2D

var freeze_time = 0.5

func _ready():
	super._ready()
	velocity = Vector2(SPEED/10, 0).rotated(angle)

func _physics_process(delta: float) -> void:
	freeze_time -= delta
	if freeze_time < 0:
		velocity = lerp(velocity, Vector2(SPEED, 0).rotated(angle), delta)
	move_and_slide()
