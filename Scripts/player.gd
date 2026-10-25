extends CharacterBody2D

var gravity = 10
var jump_force = 600
var speed = 300.0

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var jump_sound: AudioStreamPlayer = $JumpSound

func _physics_process(_delta):
	velocity.y += gravity
	move_and_slide()
	
	if is_on_floor():
		velocity.y = -jump_force
		jump_sound.play()

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
		
	_update_animation(dir)
		
func _update_animation(dir: float) -> void:
	# Face the direction we're moving
	if dir != 0:
		anim.flip_h = dir > 0

	# Up vs. down
	if velocity.y < 0:
		anim.play("up")   # moving up
	else:
		anim.play("down")   # moving down
