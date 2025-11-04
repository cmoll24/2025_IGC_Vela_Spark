extends EnemyGrounded
class_name EnemyCharge

@onready var player_detector = $flippable/PlayerDetector

@onready var flippable = $flippable

var charging = false
var charge_timer : float = 1

var charge_speed = 700

func _ready() -> void:
	super._ready()

func _physics_process(delta: float) -> void:
	flippable.scale.x = direction
	
	if player_detector.is_colliding():
		start_charge()
	
	if charging:
		charge_timer -= delta
		velocity.x = direction * charge_speed
		
		if charge_timer < 0:
			charging = false
			velocity.x = 0
			direction = -direction
	
	super._physics_process(delta)

func start_charge():
	charge_timer = 1
	charging = true
	
