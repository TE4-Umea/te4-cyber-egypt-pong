extends Control

@onready var animated_sprite = $AnimationContainer/AnimatedSprite2D
@onready var play_button = $PlayButton
@onready var continue_button = $ContinueButton
@onready var exit_button = $ExitButton
@onready var settings_button = $SettingsButton


var hasSave = false

func _on_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/World.tscn")

func _ready():
	animated_sprite.play("StartMenu")
	
	if !hasSave:
		continue_button.hide()


func _on_exit_button_down():
	get_tree().quit()
