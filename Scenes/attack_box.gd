extends Area2D

var duration = 1
@export var attacker: Node

func _ready():
	print_debug("Attack! by " + attacker.name)
	
func _physics_process(delta):
	duration -= delta
	
	if duration < 0:
		free()
