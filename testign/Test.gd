extends Node2D

onready var grenade_scene = preload("res://Weapons/Grenade/Grenade.tscn")
onready var ball = preload("res://etc/Ball.tscn")
onready var map = $Map

signal click(pos)

func _ready():
	connect("click", self, "click")

func _unhandled_input(event):
	if event.is_action_pressed("leftclick"):
		emit_signal("click", get_global_mouse_position())
	elif event.is_action_pressed("rightclick"):
		var b = ball.instance()
		b.global_position = get_global_mouse_position()
		add_child(b)


func spawn_grenade(pos):
	var grenade = grenade_scene.instance()
	grenade.global_position = pos
	add_child(grenade)

func click(click_pos):
	map.explode(click_pos, 25)
