extends EnemyGrounded

@onready var animation_player = $flippable/AnimatedSprite2D
@onready var flippable = $flippable

@export var VOLLEY_DURATION = 0.1
@export var VOLLEY_COOLDOWN = 5.0

var volley_timer : float = VOLLEY_DURATION
var attack_cooldown : float = VOLLEY_COOLDOWN

func _ready() -> void:
	projectile = load("res://src/projectile/arcProjectile.tscn")

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	
	if is_dead:
		return
	
	direction = sign(Global.get_player().global_position.x - global_position.x)
	flippable.scale.x = -direction
	
	attack_cooldown -= delta
	if attack_cooldown < 0.5:
		animation_player.play("attack")
	
	attack_cooldown -= delta
	if attack_cooldown <= 0:
		volley_timer -= delta
		if volley_timer > 0:
			summon_projectile()
		else:
			attack_cooldown = VOLLEY_COOLDOWN
			volley_timer = VOLLEY_DURATION
	
	
func summon_projectile() -> void:
	var instance : ArcProjectile = projectile.instantiate()
	instance.spawnPos = global_position
	var angle = randf_range(deg_to_rad(30),deg_to_rad(50))
	instance.SPEED = randf_range(350,450)
	instance.angle = angle if direction > 0 else PI - angle
	Global.get_projectile_tree().add_child(instance)

func die():
	if is_ridding:
		get_parent().kill_projectile()
	if is_respawnable:
		is_dead = true
		animation_player.play("death")
		flippable.modulate = Color(0.3,0.2,0.2)
		await  animation_player.animation_finished
		
		repsawn_pos = global_position
		global_position = hide_pos
	else:
		is_dead = true
		animation_player.play("death")
		flippable.modulate = Color(0.3,0.2,0.2)
		await  animation_player.animation_finished
		
		queue_free()

func _on_animated_sprite_2d_animation_finished() -> void:
	animation_player.play("idle")
