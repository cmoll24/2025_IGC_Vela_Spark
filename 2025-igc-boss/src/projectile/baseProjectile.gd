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

	
	
	
