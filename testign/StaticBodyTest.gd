extends Node2D


func _ready():
	await get_tree().idle_frame
	var bodies = $Area2D.get_overlapping_bodies()
	var areas = $Area2D.get_overlapping_areas()
	
	for body in bodies:
		if body is Chunk:
			print("yay chunk")


#	call_deferred("print_text", "test1")
#	print_text("test2")
#
#func print_text(string):
#	print(string)
