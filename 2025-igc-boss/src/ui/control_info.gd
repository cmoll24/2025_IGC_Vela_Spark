extends Control

@onready var label = $Label

@export var keyboard_text : String
@export var controller_text : String
@export var touchscreen_text : String

func _ready() -> void:
	match Global.current_input_method:
		Global.INPUT_METHOD.KEYBOARD:
			label.text = keyboard_text
			return
		Global.INPUT_METHOD.CONTROLLER:
			label.text = controller_text
			return
		Global.INPUT_METHOD.TOUCH_SCREEN:
			label.text = touchscreen_text
			return
