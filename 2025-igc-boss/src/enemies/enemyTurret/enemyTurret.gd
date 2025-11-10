extends Enemy
class_name EnemyTurret

@export var COOLDOWN = 2

var cooldown_timer = COOLDOWN

func _ready() -> void:
	projectile = load("res://src/projectile/straightProjectile.tscn")

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	
	var player_pos = Global.get_player().global_position
	
	if global_position.distance_squared_to(player_pos) < 3_000_000:
		cooldown_timer -= delta
		if cooldown_timer < 0:
			cooldown_timer = COOLDOWN
			summon_projectile(player_pos)
	
	
func summon_projectile(target_pos : Vector2) -> void:
	var instance : StraightProjectile = projectile.instantiate()
	instance.spawnPos = global_position
	instance.SPEED = 500
	instance.angle = -global_position.angle_to_point(target_pos)
	Global.get_projectile_tree().add_child(instance)
