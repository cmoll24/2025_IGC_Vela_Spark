extends BossState
class_name TeleportState

@onready var boss_candle : PackedScene = preload("res://src/boss/boss_candle.tscn")
@onready var boss_teleport_animation : PackedScene = preload("res://src/boss/boss_teleport_animtion.tscn")

@export var boss : Boss

@export var offscreen_posiiton := Vector2(-9000,9000)

var initial_location : Vector2
var target_location : Vector2

func enter(_arg):
	boss.can_deal_damage = false
	initial_location = boss.global_position
	target_location = boss.get_next_boss_position()
	
	teleport()
	
	
func teleport():
	
	await get_tree().create_timer(0.5).timeout
	
	#boss.play_animation("teleport_disappear")
	var tele_anim : BossTeleportAnimation = boss_teleport_animation.instantiate()
	boss.get_parent().add_child(tele_anim)
	tele_anim.global_position = boss.global_position
	tele_anim.scale.x = boss.facing_direction
	tele_anim.z_index = boss.z_index
	tele_anim.start()
	
	boss.global_position = offscreen_posiiton
	
	print("SPAWN candle going from " + str(initial_location) + " to " + str(target_location))
	var candle : BossCandle = boss_candle.instantiate()
	Global.get_game_scene().current_level.add_child(candle)
	var spawn_offset = Vector2(192.132, -99.298)
	spawn_offset.x = boss.facing_direction * spawn_offset.x
	candle.global_position = initial_location + spawn_offset
	candle.set_destination(target_location, 2.5)
	
	spawn_offset.x = -spawn_offset.x
	if not boss.is_combat_phase(target_location + spawn_offset):
		boss.respawn_minions()
	else:
		boss.kill_minions()
	
	await get_tree().create_timer(1.2).timeout
	
	boss.global_position = target_location
	boss.face_middle()
	boss.play_animation("teleport_appear")
	await get_tree().create_timer(1.2).timeout
	
	#boss.global_position = target_location
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

func exit():
	boss.can_deal_damage = true
