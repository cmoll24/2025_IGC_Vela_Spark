extends Enemy

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
	cooldown -= delta
	if cooldown <= 0:
		summon_projectile()
		cooldown = 2.0
