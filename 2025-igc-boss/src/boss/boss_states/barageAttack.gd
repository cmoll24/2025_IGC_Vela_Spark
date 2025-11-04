extends BossState
class_name BarageAttack

@export var boss : Boss

@export var VOLLEY_COOLDOWN = 1.5
@export var VOLLEY_NUMBER = 5

var volley_number = VOLLEY_NUMBER
var volley_timer = VOLLEY_COOLDOWN

var projectile = load("res://src/projectile/arcBossProjectile.tscn")

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
		volley_number -= 1
		volley_timer = VOLLEY_COOLDOWN
		summon_projectile(deg_to_rad(35), 550)
		summon_projectile(deg_to_rad(55), 500)
		summon_projectile(deg_to_rad(75), 450)
	if volley_number < 0:
		transition.emit("porcupineHeal")
	

func summon_projectile(angle : float, speed = 400) -> void:
	var instance : ArcProjectile = projectile.instantiate()
	instance.spawnPos = boss.global_position
	var x_diff = Global.get_player().global_position.x - boss.global_position.x
	instance.SPEED = speed
	instance.angle = angle if x_diff > 0 else PI - angle
	#instance.target_x = player_x - boss.global_position.x
	#instance.arc_height = 30
	Global.get_projectile_tree().add_child(instance)
