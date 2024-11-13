extends Node2D
class_name ExplosionShape

var size
var points : PackedVector2Array

func return_translated_copy(position):
	var new_points = PackedVector2Array()
	for point in points:
		new_points.append(point + position)
	return new_points
