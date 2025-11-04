extends EnemyGrounded
class_name EnemyBarrage

@export var VOLLEY_COOLDOWN = 3

var volley_timer = VOLLEY_COOLDOWN

func _ready() -> void:
	projectile = load("res://src/projectile/arcProjectile.tscn")

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	
	volley_timer -= delta
	if volley_timer < 0:
		volley_timer = VOLLEY_COOLDOWN
		summon_projectile(deg_to_rad(30), 300)
		summon_projectile(deg_to_rad(55), 400)
		summon_projectile(deg_to_rad(80), 500)
	
	
func summon_projectile(angle : float, proj_speed = 400) -> void:
	var instance : ArcProjectile = projectile.instantiate()
	instance.spawnPos = global_position
	instance.SPEED = proj_speed
	instance.angle = angle if direction > 0 else PI - angle
	Global.get_projectile_tree().add_child(instance)
