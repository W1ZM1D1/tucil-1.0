extends Control

@onready var highscore_label = $main_container/highscore
@onready var start_button = $main_container/menu/start

func _ready():
	start_button.grab_focus()
	highscore_label.text = "HIGHSCORE\n" + str( Savenload.highest_score )
	

func _on_start_pressed():
	get_tree().change_scene_to_file("res://Scenes/main.tscn")

func _on_exit_pressed():
	get_tree().quit()
	
func _on_save_pressed() -> void:
	Savenload.highest_score = Global.highscore
	highscore_label.text = "HIGHSCORE\n" + str(Global.highscore)
	Savenload.save_score()
