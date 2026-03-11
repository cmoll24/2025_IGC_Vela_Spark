extends Level

## LEVEL 10 is a specifal level - this is the cutscene

func _ready() -> void:
	Global.get_game_scene().hide_UI()

func _on_cut_scene_animation_finished() -> void:
	Global.get_game_scene().show_UI()
	Global.get_game_scene().load_level(2)
