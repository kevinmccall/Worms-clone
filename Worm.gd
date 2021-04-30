extends KinematicBody2D

var input
var current_state = States.WALKING
var velocity

enum States {WALKING, SWINGING}

func _process(delta):
	input = get_input()
	velocity = input * Vector2(1, 0)
	

func get_input():
	var input = Vector2.ZERO
	input.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	input.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	return input

func process_state():
	match current_state:
		States.WALKING:
			move_and_slide_with_snap(velcocity, )
		States.SWINGING:
			pass
