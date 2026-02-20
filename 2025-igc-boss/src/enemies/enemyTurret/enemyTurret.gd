extends Enemy
class_name EnemyTurret

@onready var animation_player = $AnimationPlayer
@onready var animated_sprite = $rotate/AnimatedSprite2D
@onready var mouth_animation = $rotate/MouthAnimation

@export var COOLDOWN = 3

var cooldown_timer = 2.5

func _ready() -> void:
	projectile = load("res://src/projectile/straightProjectile.tscn")

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	
	var player_pos = Global.get_player().global_position
	
	if global_position.distance_squared_to(player_pos) < 3_000_000:
		cooldown_timer -= delta
		if cooldown_timer < 0.8:
			animation_player.play("shoot")
		if cooldown_timer < 0:
			cooldown_timer = COOLDOWN
			summon_projectile(player_pos)
			mouth_animation.play("idle")
		if cooldown_timer < 1:
			mouth_animation.play("shoot")
	
func summon_projectile(target_pos : Vector2) -> void:
	var instance : StraightProjectile = projectile.instantiate()
	instance.spawnPos = global_position
	instance.SPEED = 460
	instance.angle = -global_position.angle_to_point(target_pos)
	Global.get_projectile_tree().add_child(instance)
