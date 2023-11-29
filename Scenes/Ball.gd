extends CharacterBody2D
@export var speed : float = 300.0
var direction = Vector2.ZERO
var paused = false

func getFunction():
	return position

func _ready():
	direction.y = randf_range(-1.0, 1.0)
	direction.x = [-1].pick_random()

func _physics_process(delta):
	if !paused:
		if direction:
			velocity = direction * speed
		else:
			velocity = velocity.move_toward(Vector2.ZERO, speed)
		move_and_slide()
	


func _on_world_pause_signal():
	paused = true
