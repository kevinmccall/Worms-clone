extends CharacterBody2D

var speed = 100

func _process(delta):
	var move_to = (get_global_mouse_position() - global_position).normalized()
	if global_position.distance_to(get_global_mouse_position()) < 5:
		move_to = Vector2.ZERO
	
	if move_to.x < 0:
		$Sprite2D.flip_h = true
	else:
		$Sprite2D.flip_h = false
	set_velocity(move_to * speed)
	move_and_slide()
	

