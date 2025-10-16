extends CharacterBody2D
class_name Projectile

@export var SPEED = 1000

var direction : float
var spawnPos : Vector2
var spawnRot : float

func _ready():
	global_position = spawnPos
	global_rotation = spawnRot
	self.add_to_group("projectiles")

func collide(body: Node2D) -> void:
	if not body.is_in_group("projectiles"):
		if body is Player:
			body.get_hit(self.global_position)
		queue_free()
