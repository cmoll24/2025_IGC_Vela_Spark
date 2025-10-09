extends CharacterBody2D

@export var SPEED = 100

var direction : float
var spawnPos : Vector2
var spawnRot : float

func _ready():
	global_position = Vector2(892, 960)
	global_rotation = spawnRot
	
