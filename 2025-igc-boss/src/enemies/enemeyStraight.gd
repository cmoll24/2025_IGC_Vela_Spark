extends Enemy

var rng = RandomNumberGenerator.new()
var laser_duration = 10.0
var randy : float

func _ready() -> void:
	projectile = load("res://src/projectile/straightProjectile.tscn")
	randy = rng.randf_range(-10, 8)


func _physics_process(delta: float) -> void:
	velocity.y += GRAVITY * delta
	move_and_slide()
	
	cooldown -= delta
	if cooldown <= 0:
		laser_duration -= delta
		if laser_duration > 0:
			summon_projectile()
		else:
			cooldown = 5.0
			laser_duration = 10
	
	
func summon_projectile() -> void:
	var instance = projectile.instantiate()
	randy = rng.randf_range(-20, 8)
	instance.spawnPos = global_position + Vector2(0, randy)
	level.add_child(instance)
