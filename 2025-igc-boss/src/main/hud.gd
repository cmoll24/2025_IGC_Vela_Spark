extends CanvasLayer

@onready var dash_indicator = $DashIndicator
@onready var healthbar = $TextureProgressBar

func _ready() -> void:
	dash_indicator.visible = false

func setup():
	healthbar.max_value = Global.get_player().health_control.MAX_HEALTH

func _process(_delta: float) -> void:
	var player_has_dash = Global.get_player().move_control.has_dash
	dash_indicator.visible = player_has_dash
	
	healthbar.value = Global.get_player().health_control.health
	print(healthbar.value)
