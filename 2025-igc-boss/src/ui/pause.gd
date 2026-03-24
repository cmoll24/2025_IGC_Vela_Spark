extends CanvasLayer

@onready var resume = $Menu/Resume

@onready var pause_menu = $Menu
@onready var option_menu = $Options

func _ready() -> void:
	visible = false
	option_menu.close_option_menu.connect(show_pause_menu)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		var new_pause_state = not get_tree().paused
		get_tree().paused = new_pause_state
		visible = new_pause_state
		resume.grab_focus()
		if new_pause_state:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

func _on_resume_pressed() -> void:
	var pause_event = InputEventAction.new()
	pause_event.action = "pause"
	pause_event.pressed = true
	Input.parse_input_event(pause_event)

func _on_options_pressed() -> void:
	pause_menu.hide()
	option_menu.open()

func show_pause_menu():
	pause_menu.show()
	resume.grab_focus()

func _on_quit_pressed() -> void:
	get_tree().paused = false
	Global.switch_to_title()
