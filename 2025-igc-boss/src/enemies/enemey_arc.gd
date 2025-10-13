extends Enemy

var volley_duration = 0.1

func _ready() -> void:
	projectile = load("res://src/projectile/arcProjectile.tscn")

func _physics_process(delta: float) -> void:
	
	velocity.y += GRAVITY * delta
	move_and_slide()
	
	cooldown -= delta
	if cooldown <= 0:
		volley_duration -= delta
		if volley_duration > 0:
			summon_projectile()
		else:
			cooldown = 5.0
			volley_duration = 0.1
	
	
func summon_projectile() -> void:
	var instance = projectile.instantiate()
	instance.spawnPos = global_position
	level.add_child(instance)
