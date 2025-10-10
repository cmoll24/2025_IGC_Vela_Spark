extends CharacterBody2D
class_name Projectile

@export var SPEED = 100

var direction : float
var spawnPos : Vector2
var spawnRot : float

func _ready():
	global_position = Vector2(599, 397)
	global_rotation = spawnRot
	self.add_to_group("projectiles")
	
