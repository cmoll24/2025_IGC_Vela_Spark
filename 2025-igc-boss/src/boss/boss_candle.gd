extends Node2D
class_name BossCandle

var destination : Vector2
var travel_distance : float
var total_distance : float
var current_speed : float

var SPEED : float = 900

var WAVE_AMPLITUDE : float = 5.0
var WAVE_FREQUENCY : float = 5.0

func set_destination(new_destination : Vector2, max_time : float):
	destination = new_destination
	total_distance = global_position.distance_to(destination)
	
	current_speed = max(total_distance / max_time, SPEED)

func _process(delta: float) -> void:
	if not destination:
		return
	
	var direction = global_position.direction_to(destination)
	
	travel_distance += current_speed * delta
	
	var perpendicular = Vector2(-direction.y, direction.x)
	var wave_progress = (travel_distance / total_distance) * TAU * WAVE_FREQUENCY
	var wave_offset = perpendicular * sin(wave_progress) * WAVE_AMPLITUDE
	
	var base_position = destination - direction * (total_distance - travel_distance)
	global_position = base_position + wave_offset
	
	if global_position.distance_squared_to(destination) < 100:
		queue_free()
