extends Area2D
class_name PlayerLight

@export var brightened_color = Color(1.5,1.5,1.5)

func _on_body_entered(body: Node2D) -> void:
	if body is Player or body is Enemy or body is Boss:
		body.brighten(brightened_color)


func _on_body_exited(body: Node2D) -> void:
	if body is Player or body is Enemy or body is Boss:
		body.unbrighten()
