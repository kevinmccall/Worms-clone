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
			var bitmap_section = get_bitmap_rect(bitmap, chunk_rect)
			var chunk_instance = chunk_scene.instance()
			chunk_instance.init(image_section, chunk_rect_pos, bitmap_section)
			pos_to_chunk[Vector2(x,y)] = chunk_instance
			add_child(chunk_instance)
			
	self_modulate = background_color
	map_image.unlock()
	update()

func update_chunks():
	for chunk in chunks_needing_update:
		var rect = chunk.get_rect()
		var bitmap_section = get_bitmap_rect(bitmap, rect)
#		chunk.call_deferred("recalculate_collisions", bitmap_section)
		chunk.recalculate_collisions(bitmap_section)
		chunks_needing_update.erase(chunk)

func _ready():
	resize_image()
	generate_chunks()
	
	## DELET THIS
	testing()
	

func get_bitmap_rect(original_bitmap : BitMap, rect : Rect2):
	var bm = BitMap.new()
	bm.create(rect.size)
	
	for x in range(rect.size.x):
		for y in range(rect.size.y):
			var pos = Vector2(x,y) 
			var bitmap_target = pos + rect.position
			if (pos + rect.position).x >= original_bitmap.get_size().x or (pos + rect.position).y >= original_bitmap.get_size().y:
				bm.set_bit(pos, false)
				continue
			bm.set_bit(pos, original_bitmap.get_bit(bitmap_target))
	return bm

func get_circle_points(pos : Vector2, radius: int):
	var points = PoolVector2Array()
	var start = pos - Vector2.ONE * radius
	var end = pos + Vector2.ONE * radius
	for x in range(start.x, end.x):
		for y in range(start.y, end.y):
			if pos.distance_to(Vector2(x,y)) <= radius:
				points.append(Vector2(x,y))
	return points

func set_bitmap_points(bm, points, bit):
	for point in points:
		var chunk = get_chunk_at_point(point)
		if chunk != null:
			bm.set_bit(point, bit)
			add_chunk_for_update(chunk)
		

func add_chunk_for_update(chunk):
	if not chunk in chunks_needing_update:
		chunks_needing_update.append(chunk)

func get_chunk_at_point(point):
	var chunk_pos = Vector2()
	point -= starting_pos
	chunk_pos.x = floor(point.x / chunk_size.x)
	chunk_pos.y = floor(point.y / chunk_size.y)
	if pos_to_chunk.has(chunk_pos):
		return pos_to_chunk[chunk_pos]
	else:
		print("no chunk ", chunk_pos, point)
	

## DELET THIS
func testing():
	var points = get_circle_points(Vector2(450, 450), 100)
	set_bitmap_points(bitmap, points, false)
	for chunk in chunks_needing_update:
		print(chunk.get_rect().position / chunk_size)
	update_chunks()
#	print("chunkx ", chunk_x)
#	print("chunky ", chunk_y)
#	save_bitmap_as_image(bitmap)
	print_bitmap(bitmap)
	
#func _process(delta):
#	print(get_chunk_at_point(get_global_mouse_position()))

func save_bitmap_as_image(bm : BitMap):
	var image = Image.new()
	image.create(bm.get_size().x, bm.get_size().y, false, Image.FORMAT_RGB8)
	image.lock()
	for x in range(bm.get_size().x):
		for y in range(bm.get_size().y):
			var pos = Vector2(x,y)
			var value = bm.get_bit(pos)
			if value:
				image.set_pixelv(pos, Color.white)
			else:
				image.set_pixelv(pos, Color.black)
	image.unlock()
	var h_m_s = str(OS.get_time()["hour"]) + str(OS.get_time()["minute"]) + str(OS.get_time()["second"])
	var image_name = h_m_s + ".png"
	var image_file_path = "res://testign/BitMap Visuals/"
	var error = image.save_png(image_file_path + image_name)
	if error != OK:
		print("uh oh, stinky, %s" % error)

func print_bitmap(bm : BitMap):
	var line
	for y in range(bm.get_size().y):
		line = []
		for x in range(bm.get_size().x):
			var pos = Vector2(x,y)
			line.append(int(bm.get_bit(pos)))
		print(line)
