extends CanvasLayer

@onready var player_input = $PlayerInputs
@onready var fps_label = $FPS
@onready var timer_label = $Timer

@onready var touch_screen_controls = $TouchScreenControls

var inputs = {}

@onready var healthbar = $HealthBar

func _ready() -> void:
	touch_screen_controls.visible = Global.show_touch_screen_controls()

func setup():
	healthbar.max_value = Global.get_player().health_control.MAX_HEALTH

func _process(_delta: float) -> void:
	if inputs.is_empty():
		player_input.text = "Inputs: (none)"
	else:
		player_input.text = "Inputs:\n" + "\n".join(inputs.values())
	
	healthbar.value = Global.get_player().health_control.health
	if healthbar.value == 0:
		$HealthFire.play("death")
	
	fps_label.text = "FPS: " + str(Engine.get_frames_per_second())
	timer_label.text = display_time(round(Global.player_timer)) #Time.get_time_string_from_unix_time(round(Global.player_timer))
	
func display_time(time : int) -> String:
	var seconds : int = time % 60
	var minutes : int = int(time / 60.0) % 60
	var hours : int = int(time / 3600.0)
	
	var time_string : String
	if hours > 0:
		time_string = "%d:%02d:%02d" % [hours, minutes, seconds] #str(hours) + ':' + str(minutes) + ':' + str(seconds)
	else:
		time_string = "%d:%02d" % [minutes, seconds]
	return time_string
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("debug_add_time"):
		Global.player_timer += 120
	
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
	
