extends Node
class_name BossStateMachine

@export var initial_state : BossState
@export var debug_state_label : Label

var current_state : BossState
var states : Dictionary = {}

func _ready():
	for child in get_children():
		if child is BossState:
			states[child.name.to_lower()] = child
			child.transition.connect(transition_to)
		
	if initial_state:
		transition_to(initial_state.get_name())

func _process(delta : float):
	if current_state:
		debug_state_label.text = current_state.name
		current_state.update(delta)
	
func _physics_process(delta : float):
	if current_state:
		current_state.physics_update(delta)
	
func transition_to(new_state_name : String, arg = null):
	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		return
	
	if current_state:
		#print('Boss switching: {0} -> {1}'.format([current_state.name, new_state_name]))
		current_state.exit()
	
	new_state.enter(arg)
	current_state = new_state

func get_current_state_name() -> StringName:
	return current_state.get_name()

func is_current_state(state_name : StringName):
	return get_current_state_name() == state_name
