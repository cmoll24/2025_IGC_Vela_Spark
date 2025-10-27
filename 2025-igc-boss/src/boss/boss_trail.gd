extends Line2D
class_name BossTrail

@onready var animation_player = $AnimationPlayer

func _ready() -> void:
	hide()

func draw_trail(from_pos : Vector2, to_pos : Vector2):
	set_point_position(0, from_pos)
	set_point_position(1, to_pos)
	
	show()
	animation_player.play()

func disapear():
	queue_free()
