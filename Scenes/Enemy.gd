extends CharacterBody2D


@export var speed : float = 250.0
var paused = false
var rng = RandomNumberGenerator.new()
var screensize

var bot_fail = rng.randi_range(1, 5)
var bot_success = 0
var max_bounce_angle = 5*PI/24
var recently_hit = false

func _ready():
	screensize = get_viewport().get_visible_rect().size

func bot_reset():
	bot_fail = rng.randi_range(1, 5)
	bot_success = 0
	print(bot_fail)

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
		modulate.a = 1
	else:
		modulate.a = 0.25

	if bot_success < bot_fail && ball_position.x < position.x:
		if position.y < ball_position.y: return 1
		elif position.y > ball_position.y: return -1


func _on_area_2d_body_entered(body):
	if bot_success < bot_fail:
		bot_success += 1
		bounce(body)


func _on_world_pause_signal():
	paused = true

func _on_recent_hit_timer_timeout():
	recently_hit = false

func _on_fail(body):
	bot_reset()


func _on_success(body):
	bot_reset()
