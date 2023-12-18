extends CharacterBody2D

var speed : float = 500
var attack : float = 1
var shot_speed = 1
var rng = RandomNumberGenerator.new()
var item_name
var paused = false
var max_bounce_angle = 5*PI/24
var recently_hit = false

signal hit

func _ready():
	item_name = get_parent().get_node("Control/ItemName")
	random_start()
	$Paddle.play("Idle")

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

func random_start():
	var choice = rng.randi_range(1, 6)
	print("Choice:", choice)
	if choice == 1:
		speed *= 2
		item_name.text = "Item: \nHot Chili"
	elif choice == 2:
		speed *= 0.6
		item_name.text = "Item: \nSnail"
	elif choice == 3:
		print($".".transform.y)
		$".".transform.y *= 2
		print($".".transform.y)
		item_name.text = "Item: \nThe Long Boi"
	elif choice == 4:
		$".".transform.y *= 0.5
		item_name.text = "Item: \nBob"
	elif choice == 5:
		attack *= 2
		shot_speed *= 1.5
		item_name.text = "Item: \nHard Hitter"
	else:
		choice = rng.randi_range(1, 5)
		print("Choice:", choice)
		if choice == 1:
			speed *= 2
			$".".transform.y *= 2.5
			attack *= 4
			item_name.text = "Item: \n Ra's Might"
		else:
			print($".".transform.y)
			$".".transform.y *= 0.05
			print($".".transform.y)
			attack *= 10
			item_name.text = "Item: \nThe curse of Ra"
	if $".".transform.y > Vector2(0,3):
		$".".transform.y = Vector2(0,3)
	elif $".".transform.y < Vector2(0,0.01):
		$".".transform.y = Vector2(0,0.01)

func bounce(body):
	var collision : CollisionShape2D = $"Area2D/CollisionShape2D"
	var collision_height = collision.shape.get_rect().size.y
	
	var dist = (position.y - body.position.y)
	var normalizedDist = dist/(collision_height/2)
	
	var bounceAngle = -1 * normalizedDist * max_bounce_angle
	var dir
	if body.direction.x < 0:
		dir = 1*shot_speed
	else:
		dir = -1
	if !recently_hit:
		body.direction = Vector2(cos(bounceAngle) * dir, sin(bounceAngle))
		recently_hit = true
		$RecentHitTimer.start()

func _on_area_2d_body_entered(body):
	bounce(body)
	hit.emit()

func _on_world_pause_signal():
	paused = !paused


func _on_recent_hit_timer_timeout():
	recently_hit = false
