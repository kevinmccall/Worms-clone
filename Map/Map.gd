extends Sprite2D

@onready var map_image : Image = texture.get_image()
@onready var chunk_scene = preload("res://Chunk/Chunk.tscn")

@export var generation_threshold := 0.1
@export var chunk_size := Vector2i(32, 32)
@export var background_color := Color("808080")

var bitmap = null
var chunks_needing_update = []

var chunk_x
var chunk_y 
var starting_pos 
var pos_to_chunk = {} 
var mask : Image
var mask_texture : ImageTexture


func _ready():
	resize_image()
	move(global_position)
	generate_chunks()
	init_visuals()


func move(new_position):
	var rounded_pos = Vector2i(round(new_position.x), round(new_position.y))
	global_position = rounded_pos


func resize_image():
	var new_size = Vector2(map_image.get_size()) * scale
	map_image.resize(new_size.x, new_size.y)
	
	scale = Vector2.ONE
	var updated_texture = ImageTexture.create_from_image(map_image)
	texture = updated_texture


func generate_chunks():
	var stop = map_image.get_used_rect().size
	chunk_x = int(ceil(stop.x / chunk_size.x))
	chunk_y = int(ceil(stop.y / chunk_size.y))
	starting_pos = map_image.get_used_rect().position
	bitmap = BitMap.new()
	bitmap.create_from_image_alpha(map_image, generation_threshold)

	for x in range(chunk_x):
		for y in range(chunk_y):
			var chunk_rect_pos = starting_pos + Vector2i(x, y) * chunk_size
			var chunk_rect = Rect2(chunk_rect_pos, chunk_size)
			var bitmap_section = BitmapHelper.get_bitmap_rect(bitmap, chunk_rect)
			var chunk_instance = chunk_scene.instantiate()
			chunk_instance.init(chunk_rect_pos, bitmap_section)
			pos_to_chunk[Vector2i(x,y)] = chunk_instance
			add_child(chunk_instance)

func update_chunks():
	while chunks_needing_update != []:
		var chunk = chunks_needing_update.pop_front()
		var rect = chunk.get_rect()
		rect.position -= global_position
		var bitmap_section = BitmapHelper.get_bitmap_rect(bitmap, rect)
		chunk.recalculate_collisions(bitmap_section)
		set_visuals(bitmap_section, chunk.global_position)


func get_chunk_at_point(point):
	var chunk_pos = Vector2i()
	point -= Vector2(starting_pos)
	point -= global_position
	chunk_pos.x = int(floor(point.x / chunk_size.x))
	chunk_pos.y = int(floor(point.y / chunk_size.y))
	if pos_to_chunk.has(chunk_pos):
		return pos_to_chunk[chunk_pos]


func add_chunk_for_update(chunk):
	if not chunk in chunks_needing_update:
		chunks_needing_update.append(chunk)


func get_circle_points(pos : Vector2, radius: int):
	var points = PackedVector2Array()
	var start = pos - Vector2.ONE * radius
	var end = pos + Vector2.ONE * radius
	for x in range(start.x, end.x):
		for y in range(start.y, end.y):
			if pos.distance_to(Vector2(x,y)) <= radius:
				points.append(Vector2(x,y))
	return points


func set_bitmap_points(bm, global_points, bit):
	for point in global_points:
		var chunk = get_chunk_at_point(point)
		if chunk != null:
			bm.set_bitv(point - global_position, bit)
			add_chunk_for_update(chunk)


func explode(pos : Vector2, radius : int):
	var explosion_points = get_circle_points(pos, radius)
	set_bitmap_points(bitmap, explosion_points, false)
	update_chunks()

func set_visuals(bm : BitMap, pos : Vector2):
	var image = BitmapHelper.bitmap_to_image(bm)
	mask.blit_rect(image, Rect2(Vector2.ZERO, image.get_size()), pos)
	mask_texture.set_image(mask)
	material.set_shader_parameter("mask", mask_texture)


func init_visuals():
	mask_texture = ImageTexture.new()
	mask = Image.new()
	mask.copy_from(map_image)
	mask.convert(Image.FORMAT_LA8)
	mask_texture.create_from_image(mask)
	material.set_shader_parameter("mask", mask_texture)
