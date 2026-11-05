class_name Enemy
extends Area2D

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _physics_process(_delta: float) -> void:

	var cam := get_viewport().get_camera_2d()
	if cam == null:
		return
	var half_height := get_viewport_rect().size.y / cam.zoom.y / 2.0
	if global_position.y > cam.global_position.y + half_height + 150.0:
		queue_free()

func _on_body_entered(body: Node) -> void:
	if not body.is_in_group("player"):
		return

	
	var stomped: bool = body.velocity.y > 0 and body.global_position.y < global_position.y
	if stomped:
		body.velocity.y = -body.jump_force
		die()
	else:
		body.hit()

func die() -> void:
	queue_free()
