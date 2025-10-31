extends CanvasLayer

@onready var player_input = $PlayerInputs
@onready var fps_label = $FPS

var inputs = {}

@onready var healthbar = $TextureProgressBar

func _ready() -> void:
	pass

func setup():
	healthbar.max_value = Global.get_player().health_control.MAX_HEALTH

func _process(_delta: float) -> void:
	if inputs.is_empty():
		player_input.text = "Inputs: (none)"
	else:
		player_input.text = "Inputs:\n" + "\n".join(inputs.values())
	
	healthbar.value = Global.get_player().health_control.health
	fps_label.text = "FPS: " + str(Engine.get_frames_per_second())
		

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed and not event.echo:
			inputs["key_" + str(event.keycode)] = OS.get_keycode_string(event.keycode)
		elif not event.pressed:
			inputs.erase("key_" + str(event.keycode))
	
	elif event is InputEventJoypadButton:
		var button_name = "Button " + str(event.button_index)
		if event.pressed:
			inputs["joybtn_" + str(event.device) + "_" + str(event.button_index)] = button_name
		else:
			inputs.erase("joybtn_" + str(event.device) + "_" + str(event.button_index))
	
	elif event is InputEventJoypadMotion:
		if abs(event.axis_value) > 0.1:
			var axis_name = "Axis " + str(event.axis)
			var direction = "Right/Up" if event.axis_value > 0 else "Left/Down"
			inputs["joyaxis_" + str(event.device) + "_" + str(event.axis)] = axis_name + " " + direction + " " + str(event.axis_value)
		else:
			inputs.erase("joyaxis_" + str(event.device) + "_" + str(event.axis))
	
