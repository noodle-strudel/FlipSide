extends KinematicBody2D

# the signal touch_floor is emitted and can be used by other nodes in the tree that have a script
signal touch_floor
signal jumped
signal air_jumped
signal ded

onready var air_swoosh_scene = preload("res://Scenes/air_swoosh.tscn")
onready var hit_sparkle_scene = preload("res://Scenes/hit_sparkle.tscn")

export (int) var speed = 500
export (int) var jump_speed = -1000
export (int) var gravity = 3000
export (Vector2) var velocity = Vector2.ZERO

# keeping track of states
export var in_the_air = true
export var has_jumped = false
export var hurting = false
export var dead = false
export var attacking = false


# renaming for ease of use
onready var sprite = $AnimatedSprite 
onready var sword_sprite = $Sword/AnimatedSprite


# determines if double-jumping is possible 
var double_jump = true

# gets velocity for keeping track of direction
var prev_x_velocity = 500
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
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if velocity.x != 0:
		prev_x_velocity = velocity.x
	if velocity.y != 0:
		prev_y_velocity = velocity.y

	for index in get_slide_count():
		var collision = get_slide_collision(index)
#		print("I collided with ", collision.collider.name)
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
				$jumpBound.play()
				has_jumped = true
				velocity.y = jump_speed
				double_jump = true
			

			elif double_jump == true:
				emit_signal("jumped")
				emit_signal("air_jumped")
				velocity.y = jump_speed
				$jumpBound2.play()
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
	
	yield(sprite, "animation_finished")
	$pushMove.play()
func hit():
	if hurting == false:
		GameSwitches.health -= 1
		if direction == "left":
			velocity.x = 500
		if direction == "right":
			velocity.x = -500

		if prev_y_velocity > 0:
			was_on_enemy_head = true
			velocity.y = -600
		hurting = true

		$HitPauseTimer.start()
		
		# plays sound when hit
		$hitHurt.play()
		
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
	if dead == false:
		$deadDie.play()
		dead = true
	yield(sprite, "animation_finished")
	emit_signal("ded")

func attack():
	# ground attack when on the ground
	if is_on_floor():
		in_the_air = false
		velocity = Vector2.ZERO
		if attacking == false:
			if Input.is_action_pressed("ui_down"):
				sprite.animation = "ground_swoosh_attack"
				create_swoosh()
			else:
				sprite.animation = "attack"
				$Sword/CollisionShape2D.disabled = false
			sword_sprite.frame = 0
			attacking = true
		
		yield(sprite, "animation_finished")
		attacking = false
		$Sword/CollisionShape2D.disabled = true
		GameSwitches.state = GameSwitches.NORMAL
		
	# otherwise, do an air attack!
	elif in_the_air:
		get_input()
		if attacking == false:
			create_swoosh()
			sprite.animation = "ground_swoosh_attack"
			attacking = true
		yield(sprite, "animation_finished")
		attacking = false
		GameSwitches.state = GameSwitches.NORMAL

func create_swoosh():
	var air_swoosh = air_swoosh_scene.instance()
	if direction == "right":
		air_swoosh.position = $SwooshRight.global_position
		air_swoosh.speed = 1000
	elif direction == "left":
		air_swoosh.get_node("Sprite").flip_h = true
		air_swoosh.position = $SwooshLeft.global_position
		air_swoosh.speed = -1000
	get_parent().add_child(air_swoosh)

func _on_Sword_body_entered(body):
	# grab the state of the 2d world
	var space_state = get_world_2d().direct_space_state
	
	# create a ray that starts at the sword's global position and goes to the enemy's global position
	var result = space_state.intersect_ray($Sword.global_position, body.global_position, [self])
	# result is now filled with information about where the ray intersected something
	
	var hit_sparkle = hit_sparkle_scene.instance()
	
	# we now can make it so the position of the hit_sparkle is at the location where the ray hit something
	hit_sparkle.position = result.position
	get_parent().add_child(hit_sparkle)
