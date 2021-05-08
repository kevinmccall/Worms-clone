extends "res://StateMachine.gd"

func _ready():
	add_state("Grounded")
	add_state("InAir")
	add_state("NinjaRoping")

func _state_logic(delta):
	if state == null:
		return
	
	match state:
		states.Grounded:
			pass
		states.InAir:
			pass
		states.NinjaRoping:
			pass

func _get_transition(delta):
	if 

func _enter_state(new_state, old_state):
	pass

func _exit_state(new_state, old_state):
	pass
