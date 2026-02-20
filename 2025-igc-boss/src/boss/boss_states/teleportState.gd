extends BossState
class_name TeleportState

@onready var boss_trail : PackedScene = load("res://src/boss/bossTrail.tscn")

@export var boss : Boss

@export var offscreen_posiiton = Vector2(-9000,9000)

var initial_location : Vector2
var target_location : Vector2

func enter(_arg):
	boss.play_animation("teleport_disappear")
	initial_location = boss.global_position
	target_location = boss.get_next_boss_position()
	
	teleport()
	
	
func teleport():
	
	await get_tree().create_timer(0.5).timeout
	
	boss.global_position = target_location
	
	var trail : BossTrail = boss_trail.instantiate()
	Global.get_game_scene().current_level.add_child(trail)
	trail.draw_trail(initial_location, target_location)
	
	if not boss.is_combat_phase(target_location):
		boss.respawn_minions()
	else:
		boss.kill_minions()
	
	boss.play_animation("teleport_appear")
	await get_tree().create_timer(1.2).timeout
	
	#boss.global_position = target_location
	boss.face_middle()
	boss.increase_boss_pos_index()
	
	var choice = randi_range(0,99)
	
	#if choice < 60:
	#	transition.emit("porcupineHeal")
	#else:
	if not boss.is_combat_phase():
		if choice < 60:
			transition.emit("barageAttack")
		else:
			transition.emit("boomerangAttack")
	else:
		transition.emit("straightAttack")
