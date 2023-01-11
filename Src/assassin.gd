extends KinematicBody2D

# the signal touch_floor is emitted and can be used by other nodes in the tree that have a script
signal touch_floor

export (int) var speed = 500
export (int) var jump_speed = -1000
export (int) var gravity = 4000
export (Vector2) var velocity = Vector2.ZERO

# keeping track of states

export var in_the_air = true
export var has_jumped = false
export var hurting = false

# renaming for ease of use
onready var sprite := $AnimatedSprite 
# assignes the variable type by seeing what is assigned to it. ex: var inferred_type := "String"


# determines if double-jumping is possible 
var double_jump = true

func get_input():
	velocity.x = 0
	if Input.is_action_pressed("ui_right"):
		velocity.x += speed
	if Input.is_action_pressed("ui_left"):
		velocity.x -= speed

func _physics_process(delta):
	print(velocity.x)
	

#	print("on wall: " , is_on_wall())
#	print("on floor: " , is_on_floor())
	
	
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if GameSwitches.state == GameSwitches.NORMAL:

		get_input()
		# going forward
		if velocity.x > 0:
			sprite.flip_h = false
		# going backward
		elif velocity.x < 0:
			sprite.flip_h = true
		# animation logic and current state
		if is_on_floor() and is_on_wall():
			push(delta);
		elif is_on_floor():
			on_floor(delta);
		else:
			in_air(delta);

		if Input.is_action_just_pressed("jump"):
			if is_on_floor():
				sprite.animation = "jump_up"
				has_jumped = true
				velocity.y = jump_speed
				double_jump = true
			

			elif double_jump == true:
				velocity.y = jump_speed 
				double_jump = false
				has_jumped = true
	elif GameSwitches.state == GameSwitches.HIT:
		hit()


func on_floor(delta):
	has_jumped = false
	double_jump = false
	if in_the_air == true:
		emit_signal("touch_floor")
		in_the_air = false

	if velocity.x == 0:
		sprite.animation = "idle"
	else:
		sprite.animation = "run"

func in_air(delta):
	in_the_air = true

	# gives the oppurtunity to jump once when you walk off a ledge w/o jumping
	if !has_jumped:
		double_jump = true
	
	# will use double jump animation once your oppurtunity to double jump has been used
	if !double_jump:
		sprite.animation = "double_jump"
	else:
		if velocity.y < 0:
			sprite.animation = "jump_up"
		elif velocity.y > 300:
			sprite.animation = "jump_down"

func push(delta):
	sprite.animation = "push"

func hit():
	if hurting == false:
		var prev_velocity = velocity.x
#		velocity.x = 0
		velocity.x = prev_velocity * -1
		hurting = true
	sprite.animation = "hit"
	yield(sprite, "animation_finished")
	GameSwitches.state = GameSwitches.NORMAL
	hurting = false
