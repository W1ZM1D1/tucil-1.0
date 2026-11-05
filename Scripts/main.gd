extends Node2D


@onready var last_platform_x = $platform_container/platform.position.x
@onready var player = $player
@onready var camera = $Camera2D
@onready var score_label = $Camera2D/score
@onready var camera_initial_position = $Camera2D.position.y
@onready var platform_container = $platform_container
@onready var initial_platform_y_position = $platform_container/platform.position.y

@export var scene_platform: PackedScene
@export var enemy_scene: PackedScene
@export var enemy_chance := 0.15
@export var enemy_min_height := 1500   
@export var enemy_clearance := 110.0


var score = 0
var is_game_over := false

func level_generator(amount):
	for i in amount:
		var prev_x = last_platform_x
		var prev_y = initial_platform_y_position

		initial_platform_y_position -= randi_range(150,250)
		var new_x = randi_range(48,512)
		last_platform_x = new_x

		var new_platform = scene_platform.instantiate() as StaticBody2D
		new_platform.position = Vector2(new_x, initial_platform_y_position)

		if enemy_scene and -initial_platform_y_position > enemy_min_height and randf() < enemy_chance:
			_try_spawn_enemy(new_platform, prev_x, prev_y)

		platform_container.call_deferred("add_child", new_platform)

func _try_spawn_enemy(platform: StaticBody2D, prev_x: float, prev_y: float):
	
	var mid_y = (prev_y + platform.position.y) / 2.0

	
	var best_x := 0
	var best_dist := -1.0
	for attempt in 15:
		var ex := randi_range(48, 512)
		var dist = min(abs(ex - prev_x), abs(ex - platform.position.x))
		if dist > best_dist:
			best_dist = dist
			best_x = ex

	
	if best_dist < enemy_clearance:
		return

	var enemy = enemy_scene.instantiate()
	enemy.position = Vector2(best_x, mid_y)   
	platform_container.call_deferred("add_child", enemy)

func _ready():
	player.died.connect(game_over)
	level_generator(20)

func _physics_process(_delta):
	if player.position.y < camera.position.y:
		camera.position.y = player.position.y
	score_update()

func score_update():
	score = int(camera_initial_position - camera.position.y)
	score_label.text = str(score)

func game_over():
	if is_game_over:
		return
	is_game_over = true
	if score > Global.highscore:
		Global.highscore = score
	get_tree().change_scene_to_file("res://Scenes/title_menu.tscn")

func _on_platform_eraser_body_entered(body):
	if body.is_in_group("player"):
		game_over()
	body.queue_free()
	level_generator(1)
