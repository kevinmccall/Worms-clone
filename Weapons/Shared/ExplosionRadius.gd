extends Area2D

var explosion_radius = 25

signal explode(pos, radius)

func explode():
	emit_signal("explode", global_position, explosion_radius)
