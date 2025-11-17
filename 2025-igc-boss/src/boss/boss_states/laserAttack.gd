extends BossState
class_name LaserAttack

@export var boss : Boss

@export var TELEGRAPH_TIME : float = 2
@export var PROJECTILE_NUMBER : int = 5

var telegraph_timer = TELEGRAPH_TIME
var projectile_amount = PROJECTILE_NUMBER

var attack_offset = 150

var projectile = load("res://src/projectile/straightProjectile.tscn")
var static_enemy = load("res://src/enemies/enemyStatic/enemeyStatic.tscn")

func enter(_arg):
	telegraph_timer = TELEGRAPH_TIME
	projectile_amount = PROJECTILE_NUMBER
#	target_location = boss.global_position + Vector2(50,0)

func physics_update(delta: float) -> void:
	telegraph_timer -= delta
	if telegraph_timer < 0:
		boss.play_animation("volley")
		attack(delta)
		transition.emit("idleState")
	
	boss.velocity.y += boss.GRAVITY * delta
	boss.velocity.x = move_toward(boss.velocity.x, 0, delta * boss.H_DECELERATION * boss.MOVE_SPEED)
	boss.move_and_slide()

func attack(_delta):
	for i in range(PROJECTILE_NUMBER):
	
		summon_projectile(Vector2(0,2 * attack_offset))
		summon_projectile(Vector2(0,attack_offset))
		summon_projectile(Vector2(0,-attack_offset))
		summon_projectile(Vector2(0,-2 * attack_offset))
		
		if i == int(0.5 * PROJECTILE_NUMBER):
			summon_enemy_projectile(Vector2(0,0))
		
		await get_tree().create_timer(0.2).timeout
	

func summon_projectile(offset : Vector2) -> void:
	var instance : StraightProjectile = projectile.instantiate()
	instance.spawnPos = boss.global_position + offset
	instance.SPEED = 450
	instance.angle = 0.0 if  boss.facing_direction > 0 else PI
	#instance.target_x = player_x - boss.global_position.x
	#instance.arc_height = 30
	instance.TIME_UNTIL_DESPAWN = 5
	Global.get_projectile_tree().add_child(instance)

func summon_enemy_projectile(offset : Vector2):
	var instance : StraightProjectile = projectile.instantiate()
	instance.spawnPos = boss.global_position + offset
	instance.SPEED = 450
	instance.angle = 0.0 if  boss.facing_direction > 0 else PI
	instance.TIME_UNTIL_DESPAWN = 5
	Global.get_projectile_tree().add_child(instance)
	instance.add_rider(static_enemy)
