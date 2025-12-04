extends Node2D
class_name Level

@onready var player = $Player
@onready var projectile_tree = $ProjectileTree
@onready var enemy_tree = $Enemies

@export var level_name : String

func _ready() -> void:
	var find_boss : Boss = get_node_or_null(NodePath("./Boss"))
	if find_boss:
		find_boss.setup_with_player(get_player())

func _process(_delta: float) -> void:
	pass

func get_player() -> Player:
	return player

func get_projectile_tree() -> Node2D:
	return projectile_tree

func get_enemy_tree() -> Node2D:
	return enemy_tree
