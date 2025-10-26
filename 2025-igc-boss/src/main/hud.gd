extends CanvasLayer

@onready var player_input = $PlayerInputs

var held_keys = {}

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	if held_keys.is_empty():
		player_input.text = "Keys: (none)"
	else:
		var key_names = []
		for key in held_keys.keys():
			key_names.append(OS.get_keycode_string(key))
		player_input.text = "Keys: " + ", ".join(key_names)
		

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.is_pressed():
			held_keys[event.keycode] = true
		else:
			held_keys.erase(event.keycode)
