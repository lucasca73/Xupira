extends Node

signal behavior_ended(name)

var behaviorName: String
var behaviorDuration: float
var ended = true

func start_state(name, duration):
	behaviorDuration = duration
	behaviorName = name
	ended = false
	print_debug("[state] ", name)

func end_state():
	ended = true
	behavior_ended.emit(behaviorName)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if ended == true:
		return
	
	behaviorDuration -= delta # Update timer
	if behaviorDuration < 0:
		end_state()
