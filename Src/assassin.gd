extends KinematicBody2D

export (int) var speed = 1200
export (int) var jump_speed = -1000
export (int) var gravity = 4000
export (Vector2) var velocity = Vector2.ZERO


# determines if double-jumping is possible 
var double_jump = false

func get_input():
	velocity.x = 0
	if Input.is_action_pressed("ui_right"):
		velocity.x += speed
	if Input.is_action_pressed("ui_left"):
		velocity.x -= speed

func _physics_process(delta):
	velocity = move_and_slide(velocity, Vector2.UP)
	velocity.y += gravity * delta
	on_floor(delta);


func on_floor(delta):
	get_input()
	print("on wall: " , is_on_wall())
	print("on floor: " , is_on_floor())
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = jump_speed
			double_jump = true

		elif double_jump == true:
			velocity.y = jump_speed 
			double_jump = false
