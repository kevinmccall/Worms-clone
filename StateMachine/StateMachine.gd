extends Node
class_name StateMachine

var state = null setget set_state
var states = {}
var previous_state = null

func _physics_process(delta):
	state._state_logic(delta)
	var transition = state._get_transition(delta)
	if transition != null:
		set_state(transition)

func set_state(new_state):
	if new_state == null:
		print("failed switch state")
		return -1

	previous_state = state
	state = new_state
	
	if previous_state != null:
		state._exit_state(state, previous_state)
	state._enter_state(state, previous_state)

func add_children_states():
	for i in range(get_child_count()):
		var current_child = get_child(i)
		states[current_child] = i
