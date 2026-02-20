extends EnemyGrounded
class_name EnemyBarrageGhost

@onready var animation_player = $flippable/AnimatedSprite2D
@onready var flippable = $flippable

@export var VOLLEY_COOLDOWN = 3.5

var volley_timer : float = VOLLEY_COOLDOWN

func _ready() -> void:
	projectile = load("res://src/projectile/arcGhostProjectile.tscn")

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	
	if is_dead:
		return
	
	direction = sign(Global.get_player().global_position.x - global_position.x)
	flippable.scale.x = -direction
	
	volley_timer -= delta
	if volley_timer < 0.5:
		animation_player.play("attack")
		
	
	if volley_timer < 0:
		volley_timer = VOLLEY_COOLDOWN
		summon_projectile(deg_to_rad(55), 450)
		summon_projectile(deg_to_rad(80), 550)
	
	
func summon_projectile(angle : float, proj_speed = 400) -> void:
	var instance : ArcProjectile = projectile.instantiate()
	instance.modulate = Color(0.557, 0.502, 0.443)
	instance.spawnPos = global_position
	instance.SPEED = proj_speed
	#instance.TIME_UNTIL_DESPAWN = 5
	instance.angle = angle if direction > 0 else PI - angle
	Global.get_projectile_tree().add_child(instance)

func die():
	if is_ridding:
		get_parent().kill_projectile()
	if is_respawnable:
		play_death_sound()
		is_dead = true
		animation_player.play("death")
		flippable.modulate = deathColor
		await  animation_player.animation_finished
		
		repsawn_pos = global_position
		global_position = hide_pos
	else:
		play_death_sound()
		is_dead = true
		animation_player.play("death")
		flippable.modulate = deathColor
		await  animation_player.animation_finished
		
		queue_free()

func _on_animated_sprite_2d_animation_finished() -> void:
	animation_player.play("idle")
