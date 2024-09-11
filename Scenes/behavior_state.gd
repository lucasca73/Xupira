extends Node
class_name BehaviorState

signal behavior_ended(name)

var debug = false

var behaviorName: String
var behaviorDuration: float
var ended = true

func _init():
	pass

func start_state(name, duration):
	behaviorDuration = duration
	behaviorName = name
	ended = false
	if debug:
		print_debug("[started state] ", name)

func end_state():
	ended = true
	behavior_ended.emit(behaviorName)

func process(delta):
	if ended == true:
		return
	
	behaviorDuration -= delta # Update timer
	if behaviorDuration < 0:
		end_state()
