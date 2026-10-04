extends Node2D

@onready var player = $player
@onready var camera = $Camera2D
@onready var score_label = $Camera2D/score
@onready var camera_initial_position = $Camera2D.position.y
@onready var platform_container = $platform_container
@onready var initial_platform_y_position = $platform_container/platform.position.y

@export var scene_platform: PackedScene

var score = 0

func level_generator(amount):
	for i in amount:
		initial_platform_y_position -= randi_range(150,250)
		var new_platform = scene_platform.instantiate() as StaticBody2D
		new_platform.position = Vector2(randi_range(48,512),initial_platform_y_position)
		platform_container.call_deferred("add_child",new_platform)

func _ready():
	level_generator(20)

func _physics_process(_delta):
	if player.position.y < camera.position.y:
		camera.position.y = player.position.y
	score_update()

func score_update():
	score = int(camera_initial_position - camera.position.y)
	score_label.text = str(score)

func _on_platform_eraser_body_entered(body):
	if body.is_in_group("player"):
		get_tree().change_scene_to_file("res://Scenes/title_menu.tscn")
		if score > Global.highscore:
			Global.highscore = score
	body.queue_free()
	level_generator(1)
