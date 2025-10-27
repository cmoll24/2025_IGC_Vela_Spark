extends CanvasLayer

@onready var resume = $Menu/Resume

func _ready() -> void:
	visible = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		var new_pause_state = not get_tree().paused
		get_tree().paused = new_pause_state
		visible = new_pause_state
		resume.grab_focus()

func _on_resume_pressed() -> void:
	var pause_event = InputEventAction.new()
	pause_event.action = "pause"
	pause_event.pressed = true
	Input.parse_input_event(pause_event)

func _on_quit_pressed() -> void:
	get_tree().paused = false
	Global.switch_to_title()
