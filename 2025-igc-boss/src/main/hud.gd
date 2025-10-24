extends CanvasLayer

@onready var dash_indicator = $DashIndicator

func _ready() -> void:
	dash_indicator.visible = false

func _process(_delta: float) -> void:
	var player_has_dash = Global.get_player().move_control.has_dash
	dash_indicator.visible = player_has_dash
