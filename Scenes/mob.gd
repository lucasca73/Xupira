extends CharacterBody2D

var _is_dead = false

func _physics_process(delta):
	if _is_dead:
		queue_free()

func _did_get_attacked(attacker_body, attacked_body, attack_box):
	if attacked_body == self:
		_is_dead = true
