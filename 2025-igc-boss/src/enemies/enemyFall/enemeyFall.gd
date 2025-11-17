extends Enemy

var cooldown = 5.0

@export var frequency : float = 4
@export var amplitude : float = 200.0

var starting_x : float
var time_passed : float

func _ready() -> void:
	projectile = load("res://src/projectile/fallProjectile.tscn")
	
	starting_x = position.x

func _physics_process(delta: float) -> void:
	time_passed += delta
	
	velocity.x = cos(frequency * time_passed) * amplitude
	
	super._physics_process(delta)
	
func _process(delta: float) -> void:
	super._process(delta)
	cooldown -= delta
	if cooldown <= 0:
		summon_projectile()
		cooldown = 2.0

	
func summon_projectile() -> void:
	var instance = projectile.instantiate()
	instance.spawnPos = global_position
	instance.SPEED = 200
	instance.angle = deg_to_rad(-90)
	Global.get_projectile_tree().add_child(instance)
