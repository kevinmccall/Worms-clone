extends State

var velocity = Vector2.ZERO
var speed = 50
const gravity = -9.81

func _state_logic(delta, input):
	velocity.x = input.x * speed
	velocity.y -= gravity
	velocity = character.move_and_slide(velocity)
	
	if velocity.x > 0:
		

func _get_transition():
	return null

func _enter_state():
	pass

func _exit_state():
	pass
