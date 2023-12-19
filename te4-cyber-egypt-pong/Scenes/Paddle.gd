extends CharacterBody2D

var speed : float = 500
var attack : float = 100
var shot_speed = 1
var paused = false
var max_bounce_angle = 5*PI/24
var recently_hit = false

signal itemSignal

func _ready():
	itemSelect()
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

func itemSelect():
	itemSignal.emit()

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

func _on_world_pause_signal():
	paused = !paused

func _on_recent_hit_timer_timeout():
	recently_hit = false


func _on_item_control_go_signal():
	itemSelect()
