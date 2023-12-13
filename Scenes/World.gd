extends Node
var screensize
@export var maxScore = 1
signal pauseSignal
@onready var animated_sprite = $Control/Background

# Called when the node enters the scene tree for the first time.
func _ready():
	screensize = get_viewport().get_visible_rect().size
	animated_sprite.play("Background")

func _on_top_body_entered(body):
	if !body.is_in_group('paddles'):
		body.direction.y *= -1


func _on_bottom_body_entered(body):
	if !body.is_in_group('paddles'):
		body.direction.y *= -1



func _on_left_body_entered(body):
	Main.health -= 1
	$Control/Label.text = str("x" + str(Main.health))
	
	await get_tree().create_timer(1).timeout
	
	$Ball.global_position = Vector2(screensize.x / 2, screensize.y / 2)
	if Main.health >= maxScore:
		$Control/Label3.text = ("You died :c")
		pauseGame()

func _on_right_body_entered(body):
	await get_tree().create_timer(1).timeout
	
	$Ball.global_position = Vector2(screensize.x / 2, screensize.y / 2)
	$Ball.direction.x *= -1

func pauseGame():
	$Control/Label3.visible = true
	$Control/PlayAgain.visible = true
	$Control/MainMenu.visible = true
	$Ball.hide()
	pauseSignal.emit()

func _on_play_again_pressed():
	Main.player_score = 0
	Main.health = 5
	get_tree().change_scene_to_file("res://Scenes/World.tscn")


func _on_main_menu_pressed():
	Main.player_score = 0
	Main.health = 5
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
