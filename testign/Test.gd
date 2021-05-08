extends Node2D

onready var grenade_scene = preload("res://Weapons/Grenade/Grenade.tscn")

func _unhandled_input(event):
	if event is InputEventMouseButton and event.is_pressed():
		spawn_grenade(get_global_mouse_position())

func spawn_grenade(pos):
	var grenade = grenade_scene.instance()
	grenade.global_position = pos
	add_child(grenade)
