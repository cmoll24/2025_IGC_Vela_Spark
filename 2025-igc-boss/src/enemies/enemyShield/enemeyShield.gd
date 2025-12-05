extends EnemyCharge
class_name EnemyShield

@onready var shield_hitbox = $flippable/shield_hitbox
@onready var shield_sprite = $flippable/ShieldSprite

func _ready() -> void:
	shield_sprite.visible = false
	super._ready()

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
		invulnerable = true
		shield_sprite.visible = true
		charge_timer -= delta
		velocity.x = direction * charge_speed
		
		if charge_timer < 0:
			shield_sprite.visible = false
			charging = false
			invulnerable = false
			velocity.x = 0
			#direction = -direction
			stunned_timer.start()
			modulate = Color(0.7,0.7,0.7)
	
	enemy_grounded_process(delta)

func _on_stuned_timer_timeout() -> void:
	modulate = Color(1,1,1)

func _on_shield_hitbox_body_entered(body: Node2D) -> void:
	if body is Player and charging:
		body.super_hit(self)
