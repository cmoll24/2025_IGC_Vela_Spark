extends Area2D

var isReady = true
var projectile
@onready var level = get_tree().current_scene
var starting_x : float

func _process(delta: float) -> void:
	position.y += 100 * delta


	
func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.hit(self)
