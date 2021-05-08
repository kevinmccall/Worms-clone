extends KinematicBody2D

var speed = 100

func _process(delta):
	var move_to = (get_global_mouse_position() - global_position).normalized()
	if global_position.distance_to(get_global_mouse_position()) < 5:
		move_to = Vector2.ZERO
	move_and_slide(move_to * speed)

