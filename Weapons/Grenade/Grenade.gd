extends RigidBody2D

func _ready():
	$ExplodeTimer.connect("timeout", Callable(self, "explode_animation"))

func explode_animation():
	$AnimationPlayer.play("Explode")
