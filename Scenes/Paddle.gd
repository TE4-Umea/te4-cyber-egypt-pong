extends CharacterBody2D


@export var speed : float = 500.0
@export var attack : float = 1
var rng = RandomNumberGenerator.new()
var paused = false
var max_bounce_angle = 5*PI/24
var recently_hit = false


func _ready():
	random_start()

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
	if choice == 1:
		speed *= 2
	elif choice == 2:
		speed *= 0.6
	elif choice == 3:
		$".".transform.y *= 2
	elif choice == 4:
		$".".transform.y *= 0.5
	elif choice == 5:
		attack *= 2
	else:
		choice = rng.randi_range(1,5)
		if choice == 1:
			speed *= 2
			$".".transform.y *= 4
			attack *= 4
		else:
			$".".transform.y *= 0.1
			attack *= 10

func bounce(body):
	var collision : CollisionShape2D = $Area2D/CollisionShape2D
	var collision_height = collision.shape.get_rect().size.y
	
	var dist = (position.y - body.position.y)
	var normalizedDist = dist/(collision_height/2)
	
	var bounceAngle = -1 * normalizedDist * max_bounce_angle
	var dir
	if body.direction.x < 0:
		dir = 1
	else:
		dir = -1
	if !recently_hit:
		body.direction = Vector2(cos(bounceAngle) * dir, sin(bounceAngle))
		recently_hit = true
		$RecentHitTimer.start()

func _on_area_2d_body_entered(body):
	bounce(body)

func _on_world_pause_signal():
	paused = true


func _on_recent_hit_timer_timeout():
	recently_hit = false
