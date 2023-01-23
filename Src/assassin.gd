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
export (int) var gravity = 2300
export (Vector2) var velocity = Vector2.ZERO

# keeping track of states
export var in_the_air = true
export var has_jumped = false
export var hurting = false
export var dead = false
export var attacking = false

# if the last thing you did was an air attack and you touched the ground, it will
# not start attacking again when you dont press the button.
export var air_attacking = false
export var charging_attack = false
export var charged_up = false

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

func _ready():
	GameSwitches.state = GameSwitches.NORMAL
	GameSwitches.health = 3

"""RAN EVERY FRAME"""
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
	
	# state logic (will replace with a switch eventually)
	if GameSwitches.state == GameSwitches.RECOVER:
		revive()
	if GameSwitches.state == GameSwitches.DED:
		ded()
		print("dead state")
	elif GameSwitches.state == GameSwitches.HIT:
		hit()
		print("hit state")
	elif GameSwitches.state == GameSwitches.ATTACK:
		attack()
	elif GameSwitches.state == GameSwitches.NORMAL:
		print("normal state")
		get_input()
		determine_direction()
		
		# you can jump when you are in normal state
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
		
		# transition to attack state
		elif Input.is_action_pressed("attack"):
			GameSwitches.state = GameSwitches.ATTACK
			
		# if just directional keys are being pressed
		else:
			if is_on_floor() and is_on_wall():
				push(delta);
			elif is_on_floor():
				on_floor(delta);
			else:
				in_air(delta);
""""""

"""LEFT & RIGHT INPUT"""
func get_input():
	velocity.x = 0
	if Input.is_action_pressed("ui_right"):
		velocity.x += speed
	if Input.is_action_pressed("ui_left"):
		velocity.x -= speed
""""""

"""NORMAL STATE FUNCTIONS"""
func determine_direction():
	# going forward
	if velocity.x > 0 or Input.is_action_pressed("ui_right"):
		sprite.flip_h = false
		sword_sprite.flip_h = false
		$Sword/CollisionShape2D.position.x = 56
		sword_sprite.position.x = 64
		direction = "right"

	# going backward
	elif velocity.x < 0 or Input.is_action_pressed("ui_left"):
		sprite.flip_h = true
		sword_sprite.flip_h = true
		$Sword/CollisionShape2D.position.x = -56
		sword_sprite.position.x = -64
		direction = "left"

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

	if in_the_air == false and GameSwitches.state == GameSwitches.NORMAL:
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
""""""

"""HIT STATE"""
func hit():
	if hurting == false:
		GameSwitches.health -= 1
		if direction == "left":
			velocity.x = 500
		if direction == "right":
			velocity.x = -500

		if prev_y_velocity > 0:
			if GameSwitches.health <= 0:
				velocity.y = -6000
			else:
				velocity.y = -600
		hurting = true

		$HitPauseTimer.start()
		
		# plays sound when hit
		$hitHurt.play()
		
		# literally pauses the game!
		get_tree().paused = true
		
		# timer is not paused because its property pause_mode is set to Process even when the game is paused

	sprite.animation = "hit"
	
	print(GameSwitches.health, " health,")
	# prevents the character from going back to a normal state if, per se, it hits the side of the enemy right as it

func _on_HitPauseTimer_timeout():
	get_tree().paused = false
	$RecoverTimer.start()

func _on_RecoverTimer_timeout():
	if GameSwitches.health <= 0:
		GameSwitches.state = GameSwitches.DED
	else:
		GameSwitches.state = GameSwitches.NORMAL
	hurting = false
""""""

"""DED STATE"""
func ded():
	print("dead???")
	velocity = Vector2.ZERO
	sprite.animation = "ded"
	if dead == false:
		$deadDie.play()
		dead = true
	
	
	yield(sprite, "animation_finished")
	if sprite.animation == "ded":
		print("emitted signal ded")
		emit_signal("ded")
""""""

"""ATTACK STATE"""
func attack():
	print("pressing attack")
	
	# ground attack when on the ground
	if is_on_floor() and air_attacking == false:
		in_the_air = false
		velocity = Vector2.ZERO
		
		# when you hold down attack button
		if charged_up == false:
			if charging_attack == false:
				# start charing animation
				sprite.animation = "charge_attack"
				charging_attack = true
			
			# if you release the attack button, do a normal attack
			if Input.is_action_just_released("attack"):
				print("normal attack")
				if attacking == false:
					sprite.animation = "attack"
					$Sword/CollisionShape2D.disabled = false
					sword_sprite.frame = 0
					attacking = true
				yield(sprite, "animation_finished")
				attacking = false
				charging_attack = false
				charged_up = false
				GameSwitches.state = GameSwitches.NORMAL
				$Sword/CollisionShape2D.disabled = true
				
			yield(sprite, "animation_finished")
			
			# if you held dwon the attack button the whole time the whole time
			if charging_attack == true:
				charged_up = true
				charging_attack == false
				GameSwitches.state = GameSwitches.ATTACK
				
		# now you have your charge!
		elif charged_up == true:
			determine_direction()
			if Input.is_action_just_released("attack"):
				if attacking == false:
					create_swoosh()
					sprite.animation = "ground_swoosh_attack"
					charging_attack = false
					sword_sprite.frame = 0
					attacking = true
				yield(sprite, "animation_finished")
				charged_up = false
				attacking = false
				GameSwitches.state = GameSwitches.NORMAL
		
	# otherwise, do an air attack!
	elif in_the_air:
		get_input()
		if attacking == false:
			create_swoosh()
			sprite.animation = "air_swoosh_attack"
			attacking = true
			air_attacking = true
		if is_on_floor():
			emit_signal("touch_floor")
			in_the_air = false
			air_attacking = false
			attacking = false
			GameSwitches.state = GameSwitches.NORMAL
		else:
			yield(sprite, "animation_finished")
			air_attacking = false
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
""""""

"""REVIVE STATE"""
func revive():
	sprite.animation = "recover"
func _on_VisibilityNotifier2D_screen_exited():
	if GameSwitches.state != GameSwitches.HIT:
		GameSwitches.state = GameSwitches.DED
