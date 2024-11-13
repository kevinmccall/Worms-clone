extends ExplosionShape
class_name ExplosionCircle

var number_of_points = 100
var radius

func _init(_radius):
	radius = _radius
	size = radius
	generate_points()

func generate_points():
	for point in range(number_of_points):
		var t = 2 * PI / number_of_points
		t *= point
		var circle_point = Vector2(cos(t) * radius, sin(t) * radius)
		points.append(circle_point)
