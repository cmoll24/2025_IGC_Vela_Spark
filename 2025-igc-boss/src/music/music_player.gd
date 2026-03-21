extends AudioStreamPlayer
class_name MusicPlayer

@export_range(-80, 24, 0.001) var default_volume : float

var NO_VOLUME = -80

func fade_in(time : float, volume : float = default_volume):
	if not self.playing:
		volume_db = NO_VOLUME
		play()
		var music_tween = get_tree().create_tween()
		music_tween.tween_property(self,'volume_db', volume, time)

func fade_out(time : float):
	if playing:
		var music_tween = get_tree().create_tween()
		music_tween.tween_property(self, 'volume_db', NO_VOLUME, time)
		music_tween.finished.connect(self.stop)
