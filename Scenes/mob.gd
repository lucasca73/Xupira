extends CharacterBody2D

var _is_dead = false
var speed = 100
var walk = 50
var max = 50

var _attack_target: CharacterBody2D
var _target_position: Vector2

func _physics_process(delta):
	
	var frame_velocity = Vector2.ZERO
	
	if _attack_target:
		var direction = (_attack_target.position - position).normalized()
		frame_velocity = direction * speed
	elif _target_position != Vector2.ZERO:
		
		var nextPosition = _target_position - position
		var reachedDestination = nextPosition.abs().length() < 2
		
		if reachedDestination:
			frame_velocity = Vector2.ZERO
			$MobBehaviorStateMachine.behavior.end_state()
		else:
			frame_velocity = nextPosition.normalized() * walk # Continue walking
	
	if frame_velocity.length() < 5:
		velocity = Vector2.ZERO
	else:
		velocity = frame_velocity.clamp(Vector2(-max, -max), Vector2(max, max))
		move_and_slide()
	
	if _is_dead:
		queue_free()

func _did_get_attacked(attacker_body, attacked_body, attack_box):
	if _attack_target == self:
		_is_dead = true

func _on_mob_behavior_state_machine_explore_position(position):
	_target_position = position + global_position
	_attack_target = null

func _on_mob_behavior_state_machine_follow_target(body):
	_attack_target = body
	_target_position = Vector2.ZERO

func _on_mob_behavior_state_machine_inside_attack_range(body):
	pass
