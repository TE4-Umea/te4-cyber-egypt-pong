extends CharacterBody2D
@export var speed : float = 300.0
var direction = Vector2.ZERO
var paused = false
var screensize

func getFunction():
	return position

func _ready():
	screensize = get_viewport().get_visible_rect().size
	direction.y = randf_range(-1.0, 1.0)
	direction.x = -1

func _process(delta):
	if position.y < 0 or position.y > screensize.y:
		direction.y *= -1

func _physics_process(delta):
	if !paused:
		if direction:
			velocity = direction * speed
		else:
			velocity = velocity.move_toward(Vector2.ZERO, speed)
		move_and_slide()
		if position.y > screensize.y:
			print(position.y)


func _on_world_pause_signal():
	paused = true
