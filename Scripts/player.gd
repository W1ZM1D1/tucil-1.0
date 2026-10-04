extends CharacterBody2D

var gravity = 10
var jump_force = 600
var speed = 300.0

func _physics_process(_delta):
	velocity.y += gravity
	move_and_slide()
	if is_on_floor():
		velocity.y = -jump_force

	var dir = 0.0
	if Input.is_action_pressed("left"):
		dir -= 1
	elif Input.is_action_pressed("right"):
		dir += 1

	if dir != 0:
		velocity.x = lerp(velocity.x, dir * speed, 0.8)
	else:
		velocity.x = lerp(velocity.x, 0.0, 0.2)
		
	if position.x < 0:
		position.x = get_viewport_rect().size.x
	elif position.x > get_viewport_rect().size.x:
		position.x = 0
