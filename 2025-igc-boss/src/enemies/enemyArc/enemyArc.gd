extends EnemyGrounded

@export var VOLLEY_DURATION = 0.1
@export var VOLLEY_COOLDOWN = 5.0

var volley_timer : float = VOLLEY_DURATION
var attack_cooldown : float = VOLLEY_COOLDOWN

func _ready() -> void:
	projectile = load("res://src/projectile/arcProjectile.tscn")

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	
	attack_cooldown -= delta
	if attack_cooldown <= 0:
		volley_timer -= delta
		if volley_timer > 0:
			summon_projectile()
		else:
			attack_cooldown = VOLLEY_COOLDOWN
			volley_timer = VOLLEY_DURATION
	
	
func summon_projectile() -> void:
	var instance : ArcProjectile = projectile.instantiate()
	instance.spawnPos = global_position
	var angle = randf_range(deg_to_rad(30),deg_to_rad(50))
	instance.SPEED = randf_range(350,450)
	instance.angle = angle if direction > 0 else PI - angle
	Global.get_projectile_tree().add_child(instance)
