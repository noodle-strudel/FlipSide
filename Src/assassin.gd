extends KinematicBody2D

# the signal touch_floor is emitted and can be used by other nodes in the tree that have a script
signal touch_floor
signal jumped
signal ded

onready var air_swoosh_scene = preload("res://Scenes/air_swoosh.tscn")

export (int) var speed = 500
export (int) var jump_speed = -1000
export (int) var gravity = 3000
export (Vector2) var velocity = Vector2.ZERO

# keeping track of states
var in_the_air = true
var has_jumped = false
var hurting = false
var attacking = false

# renaming for ease of use
onready var sprite = $AnimatedSprite 
onready var sword_sprite = $Sword/AnimatedSprite
# assignes the variable type by seeing what is assigned to it. ex: var inferred_type := "String"


# determines if double-jumping is possible 
var double_jump = true

# gets velocity for keeping track of direction
var prev_x_velocity
var prev_y_velocity

# current direction
var direction = "right"

# if you hit a hostile enemy's head
var was_on_enemy_head = false
func _ready():
	GameSwitches.state = GameSwitches.NORMAL
	GameSwitches.health = 3

func get_input():
	velocity.x = 0
	if Input.is_action_pressed("ui_right"):
		velocity.x += speed
	if Input.is_action_pressed("ui_left"):
		velocity.x -= speed

func _physics_process(delta):
	print(GameSwitches.state)
	"""DEBUGGING
	print(velocity.x)

	"""
	print(sprite.animation)
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if velocity.x != 0:
		prev_x_velocity = velocity.x
	if velocity.y != 0:
		prev_y_velocity = velocity.y

	for index in get_slide_count():
		var collision = get_slide_collision(index)
		print("I collided with ", collision.collider.name)
		if collision.collider.is_in_group("enemy"):
			GameSwitches.state = GameSwitches.HIT
		# it is now touching some sort of ground so it  
		else:
			was_on_enemy_head = false

	if GameSwitches.state == GameSwitches.DED:
		ded()
	elif GameSwitches.state == GameSwitches.HIT:
		hit()
	elif GameSwitches.state == GameSwitches.ATTACK:
		attack()
	elif GameSwitches.state == GameSwitches.NORMAL:
		get_input()

		# going forward
		if velocity.x > 0:
			sprite.flip_h = false
			sword_sprite.flip_h = false
			$Sword/CollisionShape2D.position.x = 45
			sword_sprite.position.x = 48
			direction = "right"

		# going backward
		elif velocity.x < 0:
			sprite.flip_h = true
			sword_sprite.flip_h = true
			$Sword/CollisionShape2D.position.x = -45
			sword_sprite.position.x = -48
			direction = "left"

		# animation logic and current state
		if is_on_floor() and is_on_wall():
			push(delta);
		elif is_on_floor():
			on_floor(delta);
		else:
			in_air(delta);

		if Input.is_action_just_pressed("jump"):
			if is_on_floor():
				emit_signal("jumped")
				sprite.animation = "jump_up"
				has_jumped = true
				velocity.y = jump_speed
				double_jump = true
			

			elif double_jump == true:
				velocity.y = jump_speed 
				double_jump = false
				has_jumped = true
		elif Input.is_action_just_pressed("attack"):
			GameSwitches.state = GameSwitches.ATTACK

func on_floor(delta):
	# when you touch the floor, you are no longer jumping
	has_jumped = false
	double_jump = false
	if in_the_air == true:
		emit_signal("touch_floor")
		in_the_air = false
		sprite.animation = "landing"

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
		GameSwitches.health -= 1
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
		if GameSwitches.health <= 0:
			GameSwitches.state = GameSwitches.DED
		else:
			GameSwitches.state = GameSwitches.NORMAL
			hurting = false

func _on_HitPauseTimer_timeout():
	get_tree().paused = false

func ded():
	velocity = Vector2.ZERO
	sprite.animation = "ded"
	yield(sprite, "animation_finished")
	emit_signal("ded")

func attack():
	# ground attack when on the ground
	if is_on_floor():
		in_the_air = false
		velocity = Vector2.ZERO
		sprite.animation = "attack"

		if attacking == false:
			sword_sprite.frame = 0
			attacking = true
			$Sword/CollisionShape2D.disabled = false

		yield(sprite, "animation_finished")

		GameSwitches.state = GameSwitches.NORMAL
		$Sword/CollisionShape2D.disabled = true
		attacking = false
		
	# otherwise, do an air attack!
	else:
		var air_swoosh = air_swoosh_scene.instance()
		if direction == "right":
			air_swoosh.position = $SwooshRight.global_position
			air_swoosh.speed = 1000
		elif direction == "left":
			air_swoosh.get_node("Sprite").flip_h = true
			air_swoosh.position = $SwooshLeft.global_position
			air_swoosh.speed = -1000
		get_parent().add_child(air_swoosh)
		GameSwitches.state = GameSwitches.NORMAL
	
