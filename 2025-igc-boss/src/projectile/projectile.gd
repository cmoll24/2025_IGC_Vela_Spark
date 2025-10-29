extends CharacterBody2D
class_name Projectile

@export var SPEED = 1000

@export var angle : float = 0
@export var spawnPos : Vector2 = Vector2.ZERO
@export var spawnRot : float = 0

var despawn_timer = 10

func _ready():
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
		if body is Player:
			body.hit(self)
		#await get_tree().create_timer(1).timeout
		queue_free()
