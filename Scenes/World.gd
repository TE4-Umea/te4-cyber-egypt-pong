extends Node
var screensize
@export var maxScore = 11
signal pauseSignal

# Called when the node enters the scene tree for the first time.
func _ready():
	screensize = get_viewport().get_visible_rect().size

func _on_norr_body_entered(body):
	if !body.is_in_group('paddles'):
		body.direction.y *= -1


func _on_bottom_body_entered(body):
	if !body.is_in_group('paddles'):
		body.direction.y *= -1


func _on_kanye_body_entered(body):
	Main.enemy_score += 1
	$Control/Label2.text = str("x" + str(Main.enemy_score))
	
	await get_tree().create_timer(1).timeout
	
	$Ball.global_position = Vector2(screensize.x / 2, screensize.y / 2)
	if Main.enemy_score >= maxScore:
		$Control/Label3.text = ("Player 2 won")
		pauseGame()

func _on_left_body_entered(body):#!left
	Main.player_score += 1
	$Control/Label.text = str("x" + str(Main.player_score))
	
	await get_tree().create_timer(1).timeout
	
	$Ball.global_position = Vector2(screensize.x / 2, screensize.y / 2)
	if Main.player_score >= maxScore:
		$Control/Label3.text = ("Player 1 won")
		pauseGame()
	

func pauseGame():
	$Control/Label3.visible = true
	$Control/PlayAgain.visible = true
	$Control/MainMenu.visible = true
	$Ball.hide()
	pauseSignal.emit()

func _on_play_again_pressed():
	Main.player_score = 0
	Main.enemy_score = 0
	get_tree().change_scene_to_file("res://Scenes/World.tscn")


func _on_main_menu_pressed():
	Main.player_score = 0
	Main.enemy_score = 0
	get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
