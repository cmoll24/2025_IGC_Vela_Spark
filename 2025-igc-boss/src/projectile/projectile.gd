extends CharacterBody2D
class_name Projectile

@export var SPEED = 1000
@export var TIME_UNTIL_DESPAWN = 10

@export var angle : float = 0
@export var spawnPos : Vector2 = Vector2.ZERO
@export var spawnRot : float = 0

var despawn_timer = TIME_UNTIL_DESPAWN

var enemy_rider : Enemy
var is_ridden = false

func _ready():
	despawn_timer = TIME_UNTIL_DESPAWN
	global_position = spawnPos
	global_rotation = spawnRot
	self.add_to_group("projectiles")
	
	velocity = Vector2(SPEED, 0).rotated(-angle)

func _process(delta: float) -> void:
	despawn_timer -= delta
	if despawn_timer <= 0:
		queue_free()

func collide(body: Node2D) -> void:
	if not body.is_in_group("projectiles"):
		if body is Player and not is_ridden:
			body.hit(self)
		#elif is_ridden:
			#pop_out_rider()
		queue_free()

func add_rider(enemy_scene : PackedScene) -> void:
	var enemy = enemy_scene.instantiate()
	
	is_ridden = true
	enemy.is_ridding = true
	enemy_rider = enemy
	add_child(enemy)
	#enemy.process_mode = Node.PROCESS_MODE_DISABLED
	enemy_rider.position = Vector2.ZERO

func pop_out_rider() -> void:
	is_ridden = false
	remove_child(enemy_rider)
	Global.get_game_scene().current_level.get_enemy_tree().add_child(enemy_rider)
	enemy_rider.global_position = global_position
	enemy_rider.is_ridding = false
	#enemy_rider.process_mode = Node.PROCESS_MODE_INHERIT
	enemy_rider = null
	
	queue_free()

func kill_projectile():
	queue_free()
