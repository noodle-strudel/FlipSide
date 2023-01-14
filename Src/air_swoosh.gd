extends KinematicBody2D

# specifying that it has to be an integer
export var speed: int
export (Vector2) var velocity

func _ready():
	pass 

func _physics_process(delta):
	velocity.x = 0
	velocity.y = 0
	velocity.x += speed
	velocity = move_and_slide(velocity, Vector2.UP)
	
	# when it detects a collision with something that it can detect
	if get_slide_count() > 0:
		queue_free()
