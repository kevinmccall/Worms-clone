extends Node
class_name StateMachine

var state = null setget set_state
var previous_state = null

func _physics_process(delta):
	_state_logic(delta)

func _state_logic(delta):
	if state == null:
		return

func _get_transition(delta):
	return null

func _enter_state(new_state, old_state):
	pass

func _exit_state(new_state, old_state):
	pass

func set_state(new_state):
	if new_state == null:
		return

	previous_state = state
	state = new_state
	
	if previous_state != null:
		_exit_state(state, previous_state)
	_enter_state(state, previous_state)
