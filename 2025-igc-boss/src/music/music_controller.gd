extends Node
class_name MusicController

@onready var cutscene_music : MusicPlayer = $CutsceneMusic
@onready var boss_music : MusicPlayer = $BossMusic
@onready var level_music : MusicPlayer = $LevelMusic

#var quiet_audio_volume : float = -80
#var music_volume : float = -30

func setup(game_scene : Game):
	game_scene.switch_level.connect(load_level_music)

func stop_music():
	boss_music.fade_out(1)
	cutscene_music.fade_out(1)
	level_music.fade_out(1)

func load_level_music(level_index):
	if level_index == 4:
		print("Playing Boss music")
		boss_music.fade_in(0.5)
		cutscene_music.fade_out(1)
		level_music.fade_out(1)
	elif level_index == 10:
		print("Playing Cutscene music")
		cutscene_music.fade_in(2)
		boss_music.fade_out(1)
		level_music.fade_out(1)
	elif level_index >= 1:
		print("Play regular music")
		level_music.fade_in(8)
		boss_music.fade_out(5)
		cutscene_music.fade_out(5)
