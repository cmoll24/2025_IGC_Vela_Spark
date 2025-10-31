extends Enemy
class_name EnemyStatic

@export var frequency : float = 4
@export var amplitude : float = 200.0

var starting_y : float
var time_passed : float

func _ready() -> void:
	super._ready()
	
	starting_y = position.y

func _physics_process(delta: float) -> void:
	time_passed += delta
	
	velocity.y = cos(frequency * time_passed) * amplitude
	
	super._physics_process(delta)
