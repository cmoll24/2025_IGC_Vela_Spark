extends BossState
class_name StraightAttack

@export var boss : Boss

@export var TELEGRAPH_TIME : float = 0.2
@export var WAVE_NUMBER : int = 3

var telegraph_timer = TELEGRAPH_TIME

var attack_offset = 180
var up_offset = -50

var projectile = load("res://src/projectile/accelerateProjectile.tscn")
var static_enemy = load("res://src/enemies/enemyStatic/enemeyStatic.tscn")

func enter(_arg):
	telegraph_timer = TELEGRAPH_TIME
#	target_location = boss.global_position + Vector2(50,0)

func physics_update(delta: float) -> void:
	telegraph_timer -= delta
	if telegraph_timer < 0:
		attack(delta)
		transition.emit("idleState")
	
	boss.velocity.y += boss.GRAVITY * delta
	boss.velocity.x = move_toward(boss.velocity.x, 0, delta * boss.H_DECELERATION * boss.MOVE_SPEED)
	boss.move_and_slide()

func attack(_delta):
	var enemy_pos = randi_range(0,1)
	
	for i in range(WAVE_NUMBER):
		
		print('enemy pos: ', enemy_pos)
	
		if enemy_pos == 0:
			summon_enemy_projectile(Vector2(0,attack_offset + up_offset))
		else:
			summon_projectile(Vector2(0,attack_offset + up_offset))
		if enemy_pos == 1:
			summon_enemy_projectile(Vector2(0,up_offset))
		else:
			summon_projectile(Vector2(0,up_offset))
		if enemy_pos == 2:
			summon_enemy_projectile(Vector2(0,-attack_offset + up_offset))
		else:
			summon_projectile(Vector2(0,-attack_offset + up_offset))
		
		if enemy_pos == 0:
			enemy_pos += randi_range(0,1)
		elif enemy_pos == 2:
			enemy_pos += randf_range(-1,0)
		else:
			enemy_pos += randi_range(-1,1)
		
		await get_tree().create_timer(1).timeout
	

func summon_projectile(offset : Vector2) -> void:
	var instance : AccelerateProjectile = projectile.instantiate()
	instance.spawnPos = boss.global_position + offset
	instance.SPEED = 500
	instance.angle = 0.0 if  boss.facing_direction > 0 else PI
	#instance.target_x = player_x - boss.global_position.x
	#instance.arc_height = 30
	instance.TIME_UNTIL_DESPAWN = 5
	Global.get_projectile_tree().add_child(instance)

func summon_enemy_projectile(offset : Vector2):
	var instance : AccelerateProjectile = projectile.instantiate()
	instance.spawnPos = boss.global_position + offset
	instance.SPEED = 500
	instance.angle = 0.0 if  boss.facing_direction > 0 else PI
	instance.TIME_UNTIL_DESPAWN = 5
	Global.get_projectile_tree().add_child(instance)
	instance.add_rider(static_enemy)
