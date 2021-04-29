extends StaticBody2D

export var quality : int
var extents = Vector2(200, 200)
var top_left = global_position - extents / 2

func destruct(destruction_point):
	var current_extents = extents
	
#	for x in range(quality):
#		current_extents = split(destruction_point, current_extents)
#
#func split(destruction_point, current_extents):
#	find_node("Collision")
#

func _ready():
	print(find_node("Collision"))
