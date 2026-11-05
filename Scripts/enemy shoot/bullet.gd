class_name Bullet
extends Area2D

@export var speed := 350.0
@export var lifetime := 6.0

var direction := Vector2.DOWN

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	$VisibleOnScreenNotifier2D.screen_exited.connect(queue_free)

func _physics_process(delta: float) -> void:
	position += direction * speed * delta
	lifetime -= delta
	if lifetime <= 0.0:
		queue_free()

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		body.hit()
		queue_free()
	elif body is StaticBody2D:
		queue_free()  
