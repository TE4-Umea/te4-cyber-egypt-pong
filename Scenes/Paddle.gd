extends CharacterBody2D


@export var speed : float = 300.0
var paused = false

func _physics_process(delta):
	var direction
	if !paused:
		direction = get_axis('Player_UP', 'Player_DOWN')
		if direction:
			velocity.y = direction * speed
		else:
			velocity.y = move_toward(velocity.y, 0, speed)
		
		move_and_slide()

func get_axis(up, down):
	if Input.is_action_pressed(up): return -1
	elif Input.is_action_pressed(down): return 1


func _on_area_2d_body_entered(body):
	body.direction.x *= -1


func _on_world_pause_signal():
	paused = true
