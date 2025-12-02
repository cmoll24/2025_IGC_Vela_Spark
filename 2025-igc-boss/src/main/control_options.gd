extends Control


func _ready() -> void:
	$VBoxContainer/Keyboard.grab_focus()

func _on_keyboard_pressed() -> void:
	Global.set_input_method(Global.INPUT_METHOD.KEYBOARD)
	start_game()

func _on_controller_pressed() -> void:
	Global.set_input_method(Global.INPUT_METHOD.CONTROLLER)
	start_game()

func _on_touch_screen_pressed() -> void:
	Global.set_input_method(Global.INPUT_METHOD.TOUCH_SCREEN)
	start_game()

func start_game():
	Global.switch_to_level(0)
