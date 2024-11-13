extends CharacterBody2D
class_name Worm

var input
var health
@onready var state_machine = $StateMachine

func _process(delta):
	input = get_input()
	velocity = input * Vector2(1, 0)

func get_input():
	var inp = Vector2.ZERO
	inp.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	inp.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	return inp

func damage(dmg):
	health -= dmg
	if health <= 0:
		die()

func die():
	queue_free()
