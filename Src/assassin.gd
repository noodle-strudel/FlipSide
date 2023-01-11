extends KinematicBody2D

# the signal touch_floor is emitted and can be used by other nodes in the tree that have a script
signal touch_floor

export (int) var speed = 500
export (int) var jump_speed = -1000
export (int) var gravity = 3000
export (Vector2) var velocity = Vector2.ZERO

# keeping track of states

export var in_the_air = true
export var has_jumped = false
export var hurting = false

# renaming for ease of use
onready var sprite = $AnimatedSprite 
# assignes the variable type by seeing what is assigned to it. ex: var inferred_type := "String"


# determines if double-jumping is possible 
var double_jump = true

# gets velocity for keeping track of direction
var prev_x_velocity
var prev_y_velocity

# if you hit a hostile enemy's head
var was_on_enemy_head = false

func get_input():
	velocity.x = 0
	if Input.is_action_pressed("ui_right"):
		velocity.x += speed
	if Input.is_action_pressed("ui_left"):
		velocity.x -= speed

func _physics_process(delta):
	"""DEBUGGING
	print(velocity.x)
	

	for i in get_slide_count():
		var collision = get_slide_collision(i)
		print("I collided with ", collision.collider.name)
	"""
	print($AnimatedSprite.animation)
	print($AnimatedSprite.frame)
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if velocity.x != 0:
		prev_x_velocity = velocity.x
	if velocity.y != 0:
		prev_y_velocity = velocity.y

	for index in get_slide_count():
		var collision = get_slide_collision(index)
		print(collision.collider)
		if collision.collider.is_in_group("enemy"):
			GameSwitches.state = GameSwitches.HIT
		# it is now touching some sort of ground so it  
		else:
			was_on_enemy_head = false
	
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
			if in_the_air == true:
				emit_signal("touch_floor")
				in_the_air = false
				sprite.animation = "landing"
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
	print("on_floor")
	# when you touch the floor, you are no longer jumping
	has_jumped = false
	double_jump = false

	if sprite.animation == "landing":
		# wait for the animation to emit signal "animation_finished" to continue
		yield(sprite, "animation_finished")

	""""""
	if in_the_air == false:
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
	if double_jump == false:
		sprite.animation = "double_jump"
	else:
		if velocity.y < 0:
			sprite.animation = "jump_up"
		elif velocity.y > 300:
			sprite.animation = "jump_down"

func push(delta):
	in_the_air = false
	sprite.animation = "push"

func hit():
	if hurting == false:
		velocity.x = prev_x_velocity * -1

		if prev_y_velocity > 0:
			was_on_enemy_head = true
			velocity.y = -600
		hurting = true

		$HitPauseTimer.start()
		
		# literally pauses the game!
		get_tree().paused = true
		
		# timer is not paused because its property pause_mode is set to Process even when the game is paused

	sprite.animation = "hit"
	
	# prevents the character from going back to a normal state if, per se, it hits the side of the enemy right as it
	if is_on_floor() and was_on_enemy_head == false:
		GameSwitches.state = GameSwitches.NORMAL
		hurting = false

func _on_HitPauseTimer_timeout():
	get_tree().paused = false
