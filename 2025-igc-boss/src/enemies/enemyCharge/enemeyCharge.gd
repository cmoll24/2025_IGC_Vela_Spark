extends EnemyGrounded
class_name EnemyCharge

@onready var dizzy_animation = $Dizzy

@onready var animated_sprite = $flippable/AnimatedSprite2D

@onready var player_detector = $flippable/PlayerDetector
@onready var stunned_timer = $StunedTimer

@onready var flippable = $flippable

var charging = false
var charge_timer : float = 1.2

@export var WINDUP_DURATION : float = 0.57

var windup = false
var windup_timer

var charge_speed = 1_100

func _ready() -> void:
	super._ready()
	
	dizzy_animation.visible = false
	
	windup_timer = WINDUP_DURATION

func _process(delta: float) -> void:
	super._process(delta)
	
	if charging:
		animated_sprite.play("charge")
	elif windup:
		animated_sprite.play("windup")
	else:
		animated_sprite.play("idle")

func _physics_process(delta: float) -> void:
	flippable.scale.x = direction
	
	if not stunned_timer.is_stopped():
		enemy_grounded_process(delta)
		return
	
	if not charging and not windup:
		direction = sign(Global.get_player().global_position.x - global_position.x)
		if player_detector.is_colliding():
			start_windup()
	
	if windup:
		windup_timer -= delta
		if windup_timer < 0:
			start_charge()
	
	if charging:
		charge_timer -= delta
		velocity.x = direction * charge_speed
		
		if charge_timer < 0:
			charging = false
			velocity.x = 0
			#direction = -direction
			stunned_timer.start()
			modulate = Color(0.7,0.7,0.7)
			dizzy_animation.visible = true
	enemy_grounded_process(delta)
	
func enemy_grounded_process(delta):
	super._physics_process(delta)

func start_windup():
	windup = true
	windup_timer = WINDUP_DURATION

func start_charge():
	windup = false
	charge_timer = 1
	charging = true

func _on_stuned_timer_timeout() -> void:
	modulate = Color(1,1,1)
	dizzy_animation.visible = false
