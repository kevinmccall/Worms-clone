extends Sprite

onready var map_image : Image = texture.get_data()
onready var chunk_scene = preload("res://Chunk/Chunk.tscn")

export var generation_threshold := 0.1
export var chunk_size := Vector2(32, 32)
export var background_color := Color("808080")

var bitmap = null
var chunks_needing_update = []

var chunk_x
var chunk_y 
var starting_pos 
var pos_to_chunk = {}


func _ready():
	resize_image()
	generate_chunks()
	
	## DELET THIS
#	testing()


#func _process(delta):
#	print(get_chunk_at_point(get_global_mouse_position()))


func resize_image():
	var new_size = map_image.get_size() * scale
	map_image.resize(new_size.x, new_size.y)
	
	scale = Vector2.ONE
	var updated_texture = ImageTexture.new()
	updated_texture.create_from_image(map_image)
	texture = updated_texture


func generate_chunks():
	map_image.lock()
	var stop = map_image.get_used_rect().size
	chunk_x = int(ceil(stop.x / chunk_size.x))
	chunk_y = int(ceil(stop.y / chunk_size.y))
	starting_pos = map_image.get_used_rect().position
	bitmap = BitMap.new()
	bitmap.create_from_image_alpha(map_image, generation_threshold)

	for x in range(chunk_x):
		for y in range(chunk_y):
			var chunk_rect_pos = starting_pos + Vector2(x, y) * chunk_size
			var chunk_rect = Rect2(chunk_rect_pos, chunk_size)
			var image_section = map_image.get_rect(chunk_rect)
			var bitmap_section = BitmapHelper.get_bitmap_rect(bitmap, chunk_rect)
			var chunk_instance = chunk_scene.instance()
			chunk_instance.init(image_section, chunk_rect_pos, bitmap_section)
			pos_to_chunk[Vector2(x,y)] = chunk_instance
			add_child(chunk_instance)
			
	self_modulate = background_color
	map_image.unlock()
	update()


func update_chunks():
	while chunks_needing_update != []:
		var chunk = chunks_needing_update.pop_front()
		var rect = Rect2(chunk.global_position, chunk_size)
		rect.position -= global_position
		print(rect.position)
		var bitmap_section = BitmapHelper.get_bitmap_rect(bitmap, rect)
		chunk.recalculate_collisions(bitmap_section)


func get_circle_points(pos : Vector2, radius: int):
	var points = PoolVector2Array()
	var start = pos - Vector2.ONE * radius
	var end = pos + Vector2.ONE * radius
	for x in range(start.x, end.x):
		for y in range(start.y, end.y):
			if pos.distance_to(Vector2(x,y)) <= radius:
				points.append(Vector2(x,y))
	return points


func add_chunk_for_update(chunk):
	if not chunk in chunks_needing_update:
		chunks_needing_update.append(chunk)


func get_chunk_at_point(point):
	var chunk_pos = Vector2()
	point -= starting_pos
	point -= global_position
	chunk_pos.x = floor(point.x / chunk_size.x)
	chunk_pos.y = floor(point.y / chunk_size.y)
	if pos_to_chunk.has(chunk_pos):
		return pos_to_chunk[chunk_pos]

func explode(pos : Vector2, radius : int):
	var explosion_points = get_circle_points(pos, radius)
	set_bitmap_points(bitmap, explosion_points, false)
	update_chunks()
	print("boom")


## DELET THIS
func testing():
	BitmapHelper.save_bitmap_as_image(bitmap)

func set_bitmap_points(bm, points, bit):
	for point in points:
		var chunk = get_chunk_at_point(point)
		if chunk != null:
			bm.set_bit(point, bit)
			add_chunk_for_update(chunk)

func _draw():
	var rect = map_image.get_used_rect()
	draw_rect(rect, Color.blue, false)
