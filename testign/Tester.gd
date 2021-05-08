extends Control

var marker_offset = Vector2(0, -10)



func _ready():
	pass

func _process(delta):
	$CurrentPosLabel.text = str(get_global_mouse_position())

func _unhandled_input(event):
	if event.is_action_pressed("shoot"):
		print("placed marker")
		place_marker(get_global_mouse_position())

func place_marker(pos):
	var label = Label.new()
	label.text = str(pos)
	label.set_global_position(pos + marker_offset)
	add_child(label)
