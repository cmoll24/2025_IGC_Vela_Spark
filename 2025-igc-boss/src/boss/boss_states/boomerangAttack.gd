extends BossState
class_name BoomerangAttack

@export var boss : Boss

#@export var TELEGRAPH_TIME : float = 2
@export var DURATION : float = 4

#var telegraph_timer = TELEGRAPH_TIME
var timer = DURATION

var attack_offset = 100
var up_offset = -50

var projectile = load("res://src/projectile/boomerangProjectile.tscn")

var attacked = false

func enter(_arg):
	attacked = false
	timer = DURATION
	#telegraph_timer = TELEGRAPH_TIME
#	target_location = boss.global_position + Vector2(50,0)

func physics_update(delta: float) -> void:
	if not attacked:
		attack()
		attacked = true
	
	#telegraph_timer -= delta
	#if telegraph_timer < 0:
	timer -= delta
	if timer < 0:
		transition.emit("barageAttack")
	
	boss.velocity.y += boss.GRAVITY * delta
	boss.velocity.x = move_toward(boss.velocity.x, 0, delta * boss.H_DECELERATION * boss.MOVE_SPEED)
	boss.move_and_slide()

func attack():
	summon_projectile(Vector2(0,2 * attack_offset + up_offset))
	summon_projectile(Vector2(0,attack_offset + up_offset))
	summon_projectile(Vector2(0,up_offset))
	summon_projectile(Vector2(0,-attack_offset + up_offset))
	summon_projectile(Vector2(0,-2 * attack_offset + up_offset))
	

func summon_projectile(offset : Vector2) -> void:
	var instance : BoomerangProjectile = projectile.instantiate()
	instance.spawnPos = boss.global_position + offset
	instance.SPEED = 700
	instance.angle = 0.0 if  boss.facing_direction > 0 else PI
	instance.TIME_UNTIL_SWITCH = 2
	instance.FREEZE_TIME = 0.5
	instance.TIME_UNTIL_DESPAWN = DURATION + 2
	Global.get_projectile_tree().add_child(instance)
