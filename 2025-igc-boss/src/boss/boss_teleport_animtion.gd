extends Node2D
class_name BossTeleportAnimation

@onready var animated_sprite = $AnimatedSprite

func start():
	animated_sprite.play("teleport_disappear")

func _on_animated_sprite_animation_finished() -> void:
	queue_free()
