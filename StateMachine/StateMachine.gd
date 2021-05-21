extends Node
class_name StateMachine

export var starting_state : NodePath

var state : State setget set_state 
var states = []
var previous_state = null
onready var target = get_parent()

func _ready():
	for state in get_children():
		state.character = target
	set_state(get_node(starting_state))
	yield(target, "ready")


func _physics_process(delta):
	
	if state == null:
		return
	
	state._state_logic(delta, target.get_input())
	var transition = state._get_transition()
	if transition != null:
		set_state(transition)

func set_state(new_state):
	if state != null:
		state._exit_state()
	
	previous_state = state
	state = new_state
	
	if state != null:
		state._enter_state()

