extends BossState
class_name TeleportState

@onready var boss_trail : PackedScene = load("res://src/boss/bossTrail.tscn")

@export var boss : Boss

@export var offscreen_posiiton = Vector2(1000,-1000)

var initial_location : Vector2
var target_location : Vector2

func enter(_arg):
	initial_location = boss.global_position
	target_location = boss.get_next_boss_position()
	
	teleport()
	
	
func teleport():
	
	await get_tree().create_timer(1).timeout
	
	boss.global_position = offscreen_posiiton
	
	var trail : BossTrail = boss_trail.instantiate()
	Global.get_game_scene().current_level.add_child(trail)
	trail.draw_trail(initial_location, target_location)
	
	await get_tree().create_timer(1).timeout
	
	boss.global_position = target_location
	transition.emit("idleState")
