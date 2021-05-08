extends Area2D

onready var explosion_shape = _create_explosion_shape()
onready var chunk_manager = get_tree().get_nodes_in_group("ChunkManager")[0]

func _ready():
	pass


func explode():
	yield(get_tree(), "idle_frame")
	var chunks_in_blast = []
	for body in get_overlapping_bodies():
		if body is Chunk:
			chunks_in_blast.append(body)
	
	chunk_manager.explosion(global_position, explosion_shape)
	chunk_manager.update_chunks(chunks_in_blast)


func _create_explosion_shape():
	var current_shape = $CollisionShape2D.shape
	if current_shape is CircleShape2D:
		return ExplosionCircle.new(current_shape.radius)
	else:
		print("has to be a circle")
