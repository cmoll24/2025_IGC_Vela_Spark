extends Timer
var isReady = true
var projectile
@onready var level = get_tree().current_scene
var starting_x : float

func spawnProjectile() -> void:
	pass


func _on_ready() -> void:
	isReady = true # Replace with function body.
	projectile = load("res://src/projectile/fallProjectile.tscn")
	starting_x = position.x
