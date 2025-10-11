extends Enemy

func _ready() -> void:
	projectile = load("res://src/projectile/fallProjectile.tscn")
	
	
func _physics_process(delta: float) -> void:
	
	cooldown -= delta
	if cooldown <= 0:
		summon_projectile()
		cooldown = 5.0
