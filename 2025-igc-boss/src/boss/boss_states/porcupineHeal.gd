extends BossState
class_name PorcupineHeal
@export var boss : Boss

@export var PORCUPINE_DURATION = 5

var porcupine_timer = PORCUPINE_DURATION

var projectile = load("res://src/projectile/boomerangProjectile.tscn")
var static_enemy = load("res://src/enemies/enemyStatic/enemeyStatic.tscn")
  
func enter(_arg):
	porcupine_timer = PORCUPINE_DURATION
	summon_projectile(deg_to_rad(50))
	summon_projectile(deg_to_rad(130))

func physics_update(delta: float) -> void:
	porcupine_timer -= delta
	if porcupine_timer < 0:
		transition.emit("barageAttack")
	
	boss.velocity.x = 0
	boss.velocity.y += boss.GRAVITY * delta
	boss.move_and_slide()
	
func summon_projectile(angle : float) -> void:
	var instance : BoomerangProjectile = projectile.instantiate()
	instance.spawnPos = boss.global_position
	instance.angle = angle
	instance.SPEED = 500
	instance.TIME_UNTIL_SWITCH = 0.5
	instance.FREEZE_TIME = 1
	instance.TIME_UNTIL_DESPAWN = PORCUPINE_DURATION - 1.5
	Global.get_projectile_tree().add_child(instance)
	instance.add_rider(static_enemy)
