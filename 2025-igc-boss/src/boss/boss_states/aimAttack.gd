extends BossState
class_name AimAttack

@export var boss : Boss

@export var VOLLEY_COOLDOWN = 1

var volley_timer = VOLLEY_COOLDOWN

var projectile = load("res://src/projectile/arcProjectile.tscn")

func enter(_arg):
	boss.play_animation("volley")
	volley_timer = 0
#	target_location = boss.global_position + Vector2(50,0)

func physics_update(delta: float) -> void:
	volley(delta)
	
	var distance_to_player = boss.global_position.distance_squared_to(boss.player.global_position)
	
	if distance_to_player < 2_000_000:
		var choice = randf_range(0, 100)
		if choice > 50:
			transition.emit("laserAttack")
		else:
			transition.emit("barageAttack")
	
	boss.velocity.y += boss.GRAVITY * delta
	boss.velocity.x = move_toward(boss.velocity.x, 0, delta * boss.H_DECELERATION * boss.MOVE_SPEED)
	boss.move_and_slide()

func volley(delta):
	volley_timer -= delta
	if volley_timer < 0:
		volley_timer = VOLLEY_COOLDOWN
		summon_projectile(0.5, 800)
		summon_projectile(0.7, 800)
		summon_projectile(1, 800)
		summon_projectile(1.2, 800)
	

func summon_projectile(offset_percent : float = 1, speed = 800) -> void:
	var instance : ArcProjectile = projectile.instantiate()
	instance.spawnPos = boss.global_position
	#var direction_to_player = boss.global_position.direction_to(Global.get_player().global_position)
	var player_pos = Global.get_player().global_position
	var target_pos = (player_pos - boss.global_position) * Vector2(offset_percent, 1)
	#var direction = 1
	#if target_pos.x < 0:
	#	direction = -1
	#	target_pos = target_pos * Vector2(-1,1)
	
	instance.SPEED = speed
	instance.angle = angle_to_target_pos(target_pos, instance.SPEED, instance.GRAVITY)[1]
	#instance.target_x = player_x - boss.global_position.x
	#instance.arc_height = 30
	Global.get_projectile_tree().add_child(instance)

func angle_to_target_pos(target_pos, speed, gravity) -> Array[float]:
	var v = speed
	var g = gravity
	var xp = target_pos.x
	var yp = -target_pos.y
	
	var D = v**4 - g * ( g * xp**2 + 2 * yp * v**2 )
	if D >=0:
		#We can reach the target
		var theta_1 = atan2(v**2 - sqrt(D), g * xp)
		var theta_2 = atan2(v**2 + sqrt(D), g * xp)
		return [theta_1, theta_2]
	else:
		#We can't reach the target
		var theta
		if xp > 0:
			theta = deg_to_rad(45)
		else:
			theta = PI - deg_to_rad(45)
		return [theta, theta]

'''
func summon_projectile() -> void:
	var instance : Projectile = projectile.instantiate()
	instance.spawnPos = boss.global_position
	var direction_to_player = boss.global_position.direction_to(Global.get_player().global_position)
	instance.angle = direction_to_player.angle()
	Global.get_projectile_tree().add_child(instance)
'''
