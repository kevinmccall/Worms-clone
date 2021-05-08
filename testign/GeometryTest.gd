extends Node2D

var circle_pos = Vector2.ONE * 25
var circle_radius = 25
var number_of_points = 16

var square_pos = Vector2.ONE * 10
var square_extents = Vector2.ONE * 20

func _ready():
	var circle = create_circle(circle_pos, circle_radius)
	var square = create_square(square_pos, square_extents)
	var clipped = Geometry.clip_polygons_2d(square, circle)
#	var clipped = Geometry.clip_polygons_2d(circle, square)
	$StaticBody2D/CollisionPolygon2D.polygon = clipped[0]


func create_circle(pos, radius):
	var points = PoolVector2Array()
	for point in range(number_of_points):
		var t = 2 * PI / number_of_points
		t *= point
		var circle_point = Vector2(cos(t), sin(t)) * radius + pos
		points.append(circle_point)
	return points

func create_square(pos, extents):
	var points = PoolVector2Array([
		extents * Vector2(0, 1) + position,
		extents * Vector2(1, 1) + position,
		extents * Vector2(1, 0) + position,
		extents * Vector2(0, 0) + position
	])
	return points
