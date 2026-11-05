class_name EnemyShooter
extends Enemy

@export var bullet_scene: PackedScene
@export var shoot_interval := 3.0
@export var shoot_range := 450.0

@onready var shoot_timer: Timer = $ShootTimer
@onready var muzzle: Marker2D = $Muzzle
@onready var shoot_sound: AudioStreamPlayer2D = $ShootSound

var player: Node2D

func _ready() -> void:
	super()  
	player = get_tree().get_first_node_in_group("player")
	shoot_timer.wait_time = shoot_interval + randf_range(-0.3, 0.3)
	shoot_timer.timeout.connect(_attack)
	shoot_timer.start()

func _attack() -> void:
	if not is_instance_valid(player):
		return

	if not $ScreenNotifier.is_on_screen():
		return

	if global_position.distance_to(player.global_position) > shoot_range:
		return

	if not _can_see_player():
		return

	var bullet := bullet_scene.instantiate() as Bullet
	get_tree().current_scene.add_child(bullet)
	bullet.global_position = muzzle.global_position
	bullet.direction = (player.global_position - muzzle.global_position).normalized()
	bullet.rotation = bullet.direction.angle()
	shoot_sound.play()

func _can_see_player() -> bool:
	var space := get_world_2d().direct_space_state
	var query := PhysicsRayQueryParameters2D.create(
		muzzle.global_position,
		player.global_position
	)
	var result := space.intersect_ray(query)
	# Kosong = tidak ada penghalang, atau yang pertama kena memang pemain
	return result.is_empty() or result.collider == player
