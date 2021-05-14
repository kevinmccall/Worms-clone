extends StaticBody2D
class_name Chunk

var polygons
var size

func recalculate_collisions(bitmap):
	for child in get_children():
		if child is CollisionPolygon2D:
			child.queue_free()
	polygons = bitmap.opaque_to_polygons(Rect2(Vector2.ZERO, bitmap.get_size()))
	for polygon in polygons:
		var collision_shape = CollisionPolygon2D.new()
		collision_shape.polygon = polygon
		add_child(collision_shape)

func init(image : Image, pos : Vector2, bitmap : BitMap) -> void:
	image.lock()
	var image_texture = ImageTexture.new()
	image_texture.create_from_image(image)
	$Sprite.texture = image_texture
	$Sprite.material
	$Sprite.centered = false
	size = bitmap.get_size()
	recalculate_collisions(bitmap)
#	recalculate_visuals(bitmap)
	global_position = pos
	

func get_rect():
	return Rect2(global_position, size)

func recalculate_visuals(bitmap):
	var image = BitmapHelper.bitmap_to_image(bitmap)
	var image_texture = ImageTexture.new()
	image_texture.create_from_image(image)
	$Sprite.material.set_shader_param("mask", image_texture)

#func _draw():
#	draw_rect(Rect2(Vector2.ZERO, size), Color.white, false)
