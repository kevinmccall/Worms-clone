extends Sprite

export var debug : bool

var map_image : Image = texture.get_data()
var chunk_size = Vector2(32, 32)
var background_color = Color("808080")

onready var chunk_scene = preload("res://Chunk.tscn")

var chunks = {}
var drawing = {}

### REMEMBER THIS
# gay_offset = Vector2(106, -47)

func resize_image():
	var new_size = map_image.get_size() * scale
	map_image.resize(new_size.x, new_size.y)
	
	scale = Vector2.ONE
	var updated_texture = ImageTexture.new()
	updated_texture.create_from_image(map_image)
	texture = updated_texture

func generate_chunks():
	map_image.lock()
	assert(map_image.get_size() != map_image.get_used_rect().size) 
#	print(map_image.get_size())
#	print(map_image.get_used_rect().size)
	var stop = map_image.get_used_rect().size
	var chunk_x = int(ceil(stop.x / chunk_size.x))
	var chunk_y = int(ceil(stop.y / chunk_size.y))
	var starting_pos = map_image.get_used_rect().position
	drawing["x"] = chunk_x
	drawing["y"] = chunk_y
	drawing["offset"] = starting_pos
	drawing["used"] = map_image.get_used_rect()
	drawing["full"] = map_image.get_size()

	for x in range(chunk_x):
		for y in range(chunk_y):
			var chunk_rect_pos = starting_pos + Vector2(x, y) * chunk_size
			var chunk_rect = Rect2(chunk_rect_pos, chunk_size)
			var image_section = map_image.get_rect(chunk_rect)
			var chunk_instance = chunk_scene.instance()
			chunk_instance.init(image_section, chunk_rect_pos + .5 * chunk_size)
			add_child(chunk_instance)
	self_modulate = background_color
	map_image.unlock()
	update()

func generate_collision_shape():
	var bitmap = BitMap.new()
	var staticbody = StaticBody2D.new()
	bitmap.create_from_image_alpha(map_image)
	var polygons = bitmap.opaque_to_polygons(map_image.get_used_rect())
	for polygon in polygons:
		var collisionshape = CollisionPolygon2D.new()
		collisionshape.polygon = polygon
		collisionshape.position = map_image.get_used_rect().position * Vector2(1, -1)
		staticbody.add_child(collisionshape)
	add_child(staticbody)
	

func _ready():
	resize_image()
	generate_chunks()
#	generate_collision_shape()

func _draw():
	if drawing and debug:
		draw_rect(drawing['used'], Color.red, false, 3)
		var full_rect = Rect2(Vector2.ZERO, drawing['full'])
		draw_rect(full_rect, Color.purple, false, 3)
		
		var draw_offset = drawing['offset']
		for xc in range(drawing['x']):
			for yc in range(drawing['y']):
				var rect_pos = draw_offset + Vector2(xc, yc) * chunk_size
				var rect_size = chunk_size
				var rect = Rect2(rect_pos, rect_size)
				draw_rect(rect, Color.white, false, 2)
	
