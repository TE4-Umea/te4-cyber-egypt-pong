extends CharacterBody2D


@export var speed : float = 350.0
var paused = false
var rng = RandomNumberGenerator.new()
var screensize
signal spawn_signal
signal die_signal

var enemy_defence = rng.randi_range(5, 10)
var enemy_health = 3
var max_bounce_angle = 5*PI/24
var recently_hit = false

func _ready():
	screensize = get_viewport().get_visible_rect().size
	spawn_signal.emit()

func bot_reset():
	enemy_defence = rng.randi_range(5, 10)
	print(enemy_defence)

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
	
	if enemy_defence > 0 && $paddle.is_visible_in_tree() == true:
		modulate.a = 1
	else:
		modulate.a = 0.25

	if enemy_defence > 0 && ball_position.x < position.x && $paddle.is_visible_in_tree() == true:
		if position.y + (rng.randi_range(-40, 40)) < ball_position.y: return 1
		elif position.y - (rng.randi_range(-40, 40))> ball_position.y: return -1


func _on_area_2d_body_entered(body):
	if $paddle.is_visible_in_tree() == true:
		if enemy_defence > 0:
			enemy_defence -= get_parent().get_node("Player").attack
			bounce(body)
			print(enemy_defence)
		else:
			$paddle.hide()
			die_signal.emit()


func _on_world_pause_signal():
	paused = true

func _on_recent_hit_timer_timeout():
	recently_hit = false

func _on_fail(body):
	if enemy_defence <= 0:
		bot_reset()
		enemy_health -= 1
	else:
		enemy_defence -= get_parent().get_node("Player").attack
	
	if enemy_health <= 0:
		$paddle.hide()
		die_signal.emit()

func _on_success(body):
	pass
