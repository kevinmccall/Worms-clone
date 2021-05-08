extends Sprite


onready var map_image : Image = texture.get_data()
var chunk_size = Vector2(32, 32)
var background_color = Color("808080")

onready var chunk_scene = preload("res://Chunk/Chunk.tscn")
onready var chunk_manager = $ChunkManager

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
	var chunk_x = int(ceil(stop.x / chunk_size.x))
	var chunk_y = int(ceil(stop.y / chunk_size.y))
	var starting_pos = map_image.get_used_rect().position

	for x in range(chunk_x):
		for y in range(chunk_y):
			var chunk_rect_pos = starting_pos + Vector2(x, y) * chunk_size
			var chunk_rect = Rect2(chunk_rect_pos, chunk_size)
			var image_section = map_image.get_rect(chunk_rect)
			var chunk_instance = chunk_scene.instance()
			chunk_instance.init(image_section, chunk_rect_pos)
			add_child(chunk_instance)
	self_modulate = background_color
	map_image.unlock()
	update()


func _ready():
	resize_image()
	generate_chunks()
#	generate_collision_shape()

	
