extends CharacterBody2D

var _is_dead = false
var _attack_target: CharacterBody2D
var speed = 100

func _physics_process(delta):
	
	if _attack_target:
		var direction = (_attack_target.position - position).normalized()
		velocity = direction * speed
	
	move_and_slide()
	
	if _is_dead:
		queue_free()

func _did_get_attacked(attacker_body, attacked_body, attack_box):
	if _attack_target == self:
		_is_dead = true

func _character_entered_on_aware_area(body):
	if body is CharacterBody2D && body != self:
		_attack_target = body

func _character_exited_on_aware_area(body):
	if _attack_target == body:
		_attack_target = null
		velocity = Vector2.ZERO
