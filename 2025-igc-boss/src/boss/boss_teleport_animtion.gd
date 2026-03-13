extends Node2D
class_name BossTeleportAnimation

@onready var animated_sprite = $AnimatedSprite

@onready var hurt_sound = $HurtSound

func start():
	animated_sprite.play("teleport_disappear_flameless")
	hurt_sound.play()

func _on_animated_sprite_animation_finished() -> void:
	#queue_free()
	pass


func _on_hurt_sound_finished() -> void:
	queue_free()
