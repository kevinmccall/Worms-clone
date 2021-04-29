extends StaticBody2D

var polygons
var bitmap
var size

func recalculate_collisions():
	pass

func init(image : Image, pos : Vector2) -> void:
	var image_texture = ImageTexture.new()
	image_texture.create_from_image(image)
	$Sprite.texture = image_texture
	bitmap = BitMap.new()
	bitmap.create_from_image_alpha(image)
	var polygons = bitmap.opaque_to_polygons(image.get_used_rect())
	for polygon in polygons:
		var collision_shape = CollisionPolygon2D.new()
		collision_shape.polygon = polygon
		print(polygon)
		add_child(collision_shape)
	get_transform().get_scale()
	global_position = pos


