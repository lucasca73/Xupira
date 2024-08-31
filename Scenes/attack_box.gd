extends Area2D

var duration = 1
@export var attacker: Node

func _ready():
	print_debug("Attack! by " + attacker.name)
	
func _physics_process(delta):
	duration -= delta
	
	if duration < 0:
		queue_free()
	else:
		var hitted_bodies = get_overlapping_bodies()
		for body in hitted_bodies:
			if body.has_method("_did_get_attacked"):
				body._did_get_attacked(attacker, body, self)
