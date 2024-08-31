extends CharacterBody2D

var max_speed = 150
var speed = 3000
var drag = 30

var attack_hit_box = preload("res://Scenes/AttackBox.tscn")

var lastDirection: Vector2 = Vector2(0, 0)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	if Input.is_action_just_pressed("attack"):
		_attack()
	
	var direction = _read_direction_from_input()
	var new_velocity = velocity + direction * delta * speed
	velocity.x = clamp(new_velocity.x, -max_speed, max_speed)
	velocity.y = clamp(new_velocity.y, -max_speed, max_speed)
	
	# Update current position
	move_and_slide()
	_execute_drag()
	
func _execute_drag():
	if velocity.x > 0:
		if velocity.x > drag:
			velocity.x -= drag
		else:
			velocity.x = 0
	else:
		if velocity.x < -drag:
			velocity.x += drag
		else:
			velocity.x = 0
			
	if velocity.y > 0:
		if velocity.y > drag:
			velocity.y -= drag
		else:
			velocity.y = 0
	else:
		if velocity.y < -drag:
			velocity.y += drag
		else:
			velocity.y = 0
	
func _read_direction_from_input():
	var direction = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_up"):
		direction.y -= 1
	if Input.is_action_pressed("move_down"):
		direction.y += 1
	
	if direction.x != 0 || direction.y != 0:
		lastDirection = direction
		
	return direction
	
func _attack():
	var box = attack_hit_box.instantiate()
	var distance = 60
	box.attacker = self
	box.scale = Vector2(2,2)
	box.position = self.position + (distance * lastDirection)
	owner.add_child(box) # Adding in the world
