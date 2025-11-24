extends BossState
class_name BarageAttack

@export var boss : Boss

@export var VOLLEY_COOLDOWN : float = 1.5
@export var VOLLEY_NUMBER : int = 4

var volley_number = VOLLEY_NUMBER
var volley_timer = VOLLEY_COOLDOWN

var projectile = load("res://src/projectile/arcProjectile.tscn")
var static_enemy = load("res://src/enemies/enemyStatic/enemeyStatic.tscn")

func enter(_arg):
	volley_number = VOLLEY_NUMBER
	volley_timer = 0
#	target_location = boss.global_position + Vector2(50,0)

func physics_update(delta: float) -> void:
	volley(delta)
	
	boss.velocity.y += boss.GRAVITY * delta
	boss.velocity.x = move_toward(boss.velocity.x, 0, delta * boss.H_DECELERATION * boss.MOVE_SPEED)
	boss.move_and_slide()

func volley(delta):
	volley_timer -= delta
	if volley_timer < 0:
		boss.play_animation("volley")
		volley_number -= 1
		volley_timer = VOLLEY_COOLDOWN
		summon_projectile(deg_to_rad(35), 550)
		summon_projectile(deg_to_rad(55), 500)
		if volley_number >= 0:
			if volley_number == int(0.5 * VOLLEY_NUMBER):
				summon_enemy_projectile(deg_to_rad(75), 450)
			else:
				summon_projectile(deg_to_rad(75), 450)
	if volley_number < 0:
		transition.emit("laserAttack")#"laserAttack")
	

func summon_projectile(angle : float, speed = 400) -> void:
	var instance : ArcProjectile = projectile.instantiate()
	instance.spawnPos = boss.global_position
	instance.SPEED = speed
	instance.angle = angle if boss.facing_direction > 0 else PI - angle
	#instance.target_x = player_x - boss.global_position.x
	#instance.arc_height = 30
	Global.get_projectile_tree().add_child(instance)

func summon_enemy_projectile(angle : float, speed = 400) -> void:
	var instance : ArcProjectile = projectile.instantiate()
	instance.spawnPos = boss.global_position
	instance.SPEED = speed
	instance.angle = angle if boss.facing_direction > 0 else PI - angle
	#instance.target_x = player_x - boss.global_position.x
	#instance.arc_height = 30
	instance.TIME_UNTIL_DESPAWN = 3
	Global.get_projectile_tree().add_child(instance)
	instance.add_rider(static_enemy)
