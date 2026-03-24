extends CanvasLayer
class_name OptionMenu

@onready var contine_button = $Menu/Continue

@onready var master_volume = $Menu/MasterVolume
@onready var music_volume = $Menu/MusicVolume
@onready var sfx_volume = $Menu/SFXVolume

signal close_option_menu

func _ready() -> void:
	hide()
	
	master_volume.value = db_to_linear(AudioServer.get_bus_volume_db(0))
	sfx_volume.value = db_to_linear(AudioServer.get_bus_volume_db(1))
	music_volume.value = db_to_linear(AudioServer.get_bus_volume_db(2))

func open():
	show()
	contine_button.grab_focus()

func close():
	close_option_menu.emit()
	hide()


func _on_continue_pressed() -> void:
	close()

func _on_master_volume_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0, linear_to_db(value))

func _on_music_volume_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(2, linear_to_db(value))

func _on_sfx_volume_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(1, linear_to_db(value))
