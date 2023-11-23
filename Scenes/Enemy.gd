extends CharacterBody2D


@export var speed : float = 1000.0
var paused = false
var rng = RandomNumberGenerator.new()

var bot_fail = rng.randi_range(1, 5)
var bot_success = 0

func bot_reset():
	bot_fail = rng.randi_range(1, 5)
	bot_success = 0
	print(bot_fail)

func _physics_process(delta):
	var direction
	if !paused:
		direction = get_axis()
		if direction:
			velocity.y = direction * speed
		else:
			velocity.y = move_toward(velocity.y, 0, speed)
		
		move_and_slide()

func get_axis():
	var ball_position = get_parent().get_node("Ball").position
	if bot_success < bot_fail:
		if position.y < ball_position.y: return 1
		elif position.y > ball_position.y: return -1


func _on_area_2d_body_entered(body):
	body.direction.x *= -1
	bot_success += 1


func _on_world_pause_signal():
	paused = true


func _on_fail(body):
	bot_reset()


func _on_success(body):
	bot_reset()
