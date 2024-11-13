extends Node2D

@onready var grenade_scene = preload("res://Weapons/Grenade/Grenade.tscn")
@onready var ball = preload("res://etc/Ball.tscn")
@onready var map = $Map

var clicking

func _unhandled_input(event):
	if event.is_action_pressed("leftclick"):
		map.explode(get_global_mouse_position(), 25)
	elif event.is_action_pressed("rightclick"):
		var b = ball.instantiate()
		b.global_position = get_global_mouse_position()
		add_child(b)


func spawn_grenade(pos):
	var grenade = grenade_scene.instantiate()
	grenade.global_position = pos
	add_child(grenade)
