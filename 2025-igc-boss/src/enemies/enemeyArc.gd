extends Enemy

@export var VOLLEY_DURATION = 0.1
@export var VOLLEY_COOLDOWN = 5.0

var volley_timer = VOLLEY_DURATION

func _ready() -> void:
	projectile = load("res://src/projectile/arcProjectile.tscn")

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	
	cooldown -= delta
	if cooldown <= 0:
		volley_timer -= delta
		if volley_timer > 0:
			summon_projectile()
		else:
			cooldown = VOLLEY_COOLDOWN
			volley_timer = VOLLEY_DURATION
	
	
func summon_projectile() -> void:
	var instance = projectile.instantiate()
	instance.spawnPos = global_position
	level.add_child(instance)
