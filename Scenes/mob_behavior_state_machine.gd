extends Node

# SIGNALS
signal inside_attack_range(body)
signal explore_position(position)
signal follow_target(body)

# CONSTANTS
var idle = "idle"
var attack = "attack"
var follow = "follow"
var explore = "explore"

var behavior = BehaviorState.new()

@export var parent: CharacterBody2D

var next_position = Vector2.ZERO
var target: CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	behavior.behavior_ended.connect(_on_behavior_state_behavior_ended)
	startIdle()
	
func _process(delta):
	behavior.process(delta) # Update behavior duration
	
func startIdle():
	behavior.start_state(idle, 4)
	#$ExploreRange.disable_mode = true
	#$AttackRange.disable_mode = true
	#$FollowRange.disable_mode = true
	target = null # Reset target

func startExploreLastTargetPosition():
	if target == null:
		return
	
	next_position = target.global_position	# Last seen at
	target = null
	explore_position.emit(next_position)
	behavior.start_state(explore, 10) # Basically until it gets in the destination

func prepareNextPosition():
	var rangeScale = $ExploreRange/CollisionShape2D.scale
	var direction = Vector2(randi_range(-100,100)%100, randi_range(-100,100)%100).normalized()
	var magnetude = randf() * 10
	next_position = direction * rangeScale * magnetude

func startExplore():
	prepareNextPosition()
	explore_position.emit(next_position)
	behavior.start_state(explore, 4)
	#$ExploreRange.disable_mode = false
	#$FollowRange.disable_mode = false
	
func startFollow():
	behavior.start_state(follow, 2)
	#$AttackRange.disable_mode = false
	#$FollowRange.disable_mode = false
	follow_target.emit(target)
	
func startAttack():
	behavior.start_state(attack, 1)

func _on_behavior_state_behavior_ended(name):
	if name == idle:
		startExplore()
	elif name == explore:
		if target != null:
			startFollow() # Start following
		else:
			startIdle() # Back to idle
	elif [follow, attack].has(name):
		if $FollowRange.get_overlapping_bodies().has(target):
			startFollow() # Continue following
		else:
			startIdle()
	else:
		startIdle()

func _on_explore_range_body_entered(body):
	pass
		
func _on_explore_range_body_exited(body):
	if body == parent: # Should not consider self
		return
	
	if body != target: # Should not look for other bodies
		return
		
	startExploreLastTargetPosition()

func _on_follow_range_body_entered(body):
	if body == parent:
		return
	
	if target != null:
		return # Should not change targets

	if [idle, explore, attack, follow].has(behavior.behaviorName):
		target = body
		behavior.end_state()

func _on_attack_range_body_entered(body):
	if [follow].has(behavior.behaviorName) && body == target:
		inside_attack_range.emit(body)
