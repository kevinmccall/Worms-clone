extends StaticBody2D
class_name Chunk

var polygons
var bitmap

func recalculate_collisions():
	for child in get_children():
		if child is CollisionPolygon2D:
			child.queue_free()
	if not polygons:
		return
	for polygon in polygons:
		var collision_shape = CollisionPolygon2D.new()
		collision_shape.polygon = polygon
		add_child(collision_shape)
	

func update_image(new_bitmap):
	pass

func init(image : Image, pos : Vector2) -> void:
	image.lock()
	var image_texture = ImageTexture.new()
	image_texture.create_from_image(image)
	$Sprite.texture = image_texture
	$Sprite.centered = false
	bitmap = BitMap.new()
	bitmap.create_from_image_alpha(image, .01)
	polygons = bitmap.opaque_to_polygons(Rect2(Vector2.ZERO, bitmap.get_size()))
	for polygon in polygons:
#		if polygon == PoolVector2Array([Vector2(0,32), Vector2(32,32), Vector2(32,0), Vector2(0,0)]):
#			continue
		var collision_shape = CollisionPolygon2D.new()
		collision_shape.polygon = polygon
		add_child(collision_shape)
	image.unlock()
	global_position = pos
	


