extends Node2D
class_name ExplosionShape

var extents
var points : PoolVector2Array

func return_translated_copy(translation):
	var new_points = PoolVector2Array()
	for point in points:
		new_points.append(point + translation)
	return new_points
