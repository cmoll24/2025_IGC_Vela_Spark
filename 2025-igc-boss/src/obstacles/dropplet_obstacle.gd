extends Node2D

@onready var projectile = preload("res://src/projectile/fallProjectile.tscn")

func _on_timer_timeout() -> void:
	var instance = projectile.instantiate()
	print("Spawn")
	add_child(instance)
