extends KinematicBody2D

# the signal touch_floor is emitted and can be used by other nodes in the tree that have a script
signal touch_floor
signal jumped
signal air_jumped
signal ded
signal on_friendly_bat

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
export var damaged = false
export var dead = false
export var attacking = false

var can_jump = true
var going_out_of_cave = false

var gonna_jump_on_bounce_pad = false
var set_position_x

# keeping track of what the assassin collided with
var collided_with_bouncepad = false

var collided_with_big_bouncepad = false

# if the last thing you did was an air attack and you touched the ground, it will
# not start attacking again when you dont press the button.
export var air_attacking = false
export var charging_attack = false
export var charged_up = false

# renaming for ease of use
onready var sprite = $AnimatedSprite 
onready var sword_sprite = $Sword/AnimatedSprite

# snap logic for move_and_slide_with_snap
var snap = Vector2.DOWN * 16 if is_on_floor() else Vector2.ZERO

# determines if double-jumping is possible 
var double_jump = true

# gets velocity for keeping track of direction
var prev_x_velocity = 500
var prev_y_velocity

# current direction
var direction = "right"

func _ready():
	GameSwitches.state = GameSwitches.NORMAL

"""
----------------------------------------------------------------------
							RAN EVERY FRAME 
----------------------------------------------------------------------
"""
"""
every frame it calculates the y velocity
it stores what the previous velocity was if it isn't 0.
when the assassin collides with something,
	if it's an enemy,
		there's some special enemies that do certain things
		if its a bounce pad, initiate the bounce pad function
		if the coin is flipped, make it hurt the assassin instead
		if you collide with the bat and it is flipped, it doesnt hurt you
		if you collide with the fungus and it isn't flipped, it doesnt hurt you
		if it doesnt meet this criteria, then make it hurt you
	if you collided with the big bounce pad, 
		initiate big bounce function!
	if you're about to jump on a bounce pad,
		the assassin can't move until a certain point in the animation.
	
state machine for the assassin
when the assassin is in the normal state,
	they can jump, attack and go into the attack state,
	and logic for when they are in the air, on the ground, and trying to push something are executed.
"""

func _physics_process(delta):
	print(global_position)
	velocity.y += gravity * delta
	velocity = move_and_slide_with_snap(velocity, snap, Vector2.UP)
	
	if velocity.x != 0:
		prev_x_velocity = velocity.x
	if velocity.y != 0:
		prev_y_velocity = velocity.y
	
	for index in get_slide_count():
		var collision = get_slide_collision(index)
#		print("I collided with ", collision.collider.name)
		
		collided_with_bouncepad = false
		
		# handles logic when colliding with special objects
		# when hurt, don't care about what its colliding with
		if damaged == false:
			if collision.collider.is_in_group("enemy") or collision.collider.get_parent().is_in_group("enemy"):
				if ("Spike" in collision.collider.name and collision.collider.is_bounce_pad == true) || (collision.collider.name == "Ground Enemy" and GameSwitches.flipped == true):
						initiate_bounce_pad(collision)
				elif "Anti Coin" in collision.collider.name:
					GameSwitches.state = GameSwitches.HIT if GameSwitches.health > 0 else GameSwitches.DED
				elif "Flying Enemy" in collision.collider.name and GameSwitches.flipped == true:
					emit_signal("on_friendly_bat")
				elif "Fungus Enemy" in collision.collider.name and GameSwitches.flipped == false:
					pass
				else:
					GameSwitches.state = GameSwitches.HIT if GameSwitches.health > 0 else GameSwitches.DED
			elif "BigBouncepad" in collision.collider.name:
				collided_with_big_bouncepad = true
				if gonna_jump_on_bounce_pad == false and is_on_floor():
					set_position_x = position.x
					gonna_jump_on_bounce_pad = true
					$BounceDelay.start()
					collision.collider.get_node("AnimationPlayer").play("bounce")
		else:
			if ("Spike" in collision.collider.name and collision.collider.is_bounce_pad == true) || (collision.collider.name == "Ground Enemy" and GameSwitches.flipped == true):
				initiate_bounce_pad(collision)
	
	if gonna_jump_on_bounce_pad == true and collided_with_big_bouncepad == false:
		can_jump = false
		position.x = set_position_x
	
	# state logic (will replace with a switch eventually)
	match GameSwitches.state:
		GameSwitches.REVIVE:
			revive(delta)
		GameSwitches.DED:
			ded()
		GameSwitches.HIT:
			hit()
		GameSwitches.ATTACK:
			attack()
		GameSwitches.NORMAL:
			normal(delta)
""""""

# plays the animation for the small bounce pads and makes assassin unable to move during so.
func initiate_bounce_pad(collision) -> void:
	collision.collider.get_node("AnimationPlayer").play("bounce")
	if gonna_jump_on_bounce_pad == false and is_on_floor():
		set_position_x = position.x
		gonna_jump_on_bounce_pad = true
		$BounceDelay.start()

"""LEFT & RIGHT INPUT -------------------------------------------------------"""
func get_input():
	velocity.x = 0
	if Input.is_action_pressed("ui_right"):
		velocity.x += speed
	if Input.is_action_pressed("ui_left"):
		velocity.x -= speed
""""""

"""NORMAL STATE FUNCTIONS ---------------------------------------------------"""
func normal(delta):
	snap = Vector2.DOWN * 16 if is_on_floor() else Vector2.ZERO
	get_input()
	determine_direction()
		
		
# you can jump when you are in normal state
	if Input.is_action_just_pressed("jump"):
		if can_jump:
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
	elif Input.is_action_pressed("attack") and gonna_jump_on_bounce_pad == false and GameSwitches.state != GameSwitches.INACTIVE:
		GameSwitches.state = GameSwitches.ATTACK
		
	# if just directional keys are being pressed
	else:
		if is_on_floor():
			on_floor(delta);
		else:
			in_air();

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

"""
when you're on the floor, youre not jumping nor are you double jumping
emit dust particle
play landing Animation
wait for it to finish
if you're not moving and not in the air
	if the assassin is still, they idle
	else they run
"""
func on_floor(delta):
	# when you touch the floor, you are no longer jumping
	has_jumped = false
	double_jump = false
	if in_the_air == true and gonna_jump_on_bounce_pad == false:
		emit_signal("touch_floor")
	if hurting == false:
		if in_the_air == true:
			in_the_air = false
			sprite.animation = "landing"
		
		if sprite.animation == "landing":
			# wait for the animation to emit signal "animation_finished" to continue
			yield(sprite, "animation_finished")

		if in_the_air == false and attacking == false:
			if velocity.x == 0:
				sprite.animation = "idle"
			else:
				sprite.animation = "run"

func in_air():
	in_the_air = true

	# gives the oppurtunity to jump once when you walk off a ledge w/o jumping
	if has_jumped == false:
		double_jump = true
	
	# will use double jump animation once your oppurtunity to double jump has been used
	if hurting == false:
		if double_jump == false:
			sprite.animation = "double_jump"
		else:
			if velocity.y < 0:
				sprite.animation = "jump_up"
			elif velocity.y > 300:
				sprite.animation = "jump_down"
""""""

"""
you can still move while hit to evade
you lose health
if you were jumping you bounce up a little
if you are now at 0 hp, enter the DED state
"""
"""HIT STATE ----------------------------------------------------------------"""
func hit():
	get_input()
	determine_direction()
	if hurting == false:
		charged_up = false
		charging_attack = false
		GameSwitches.health -= 1
		
		if prev_y_velocity > 0:
			snap = Vector2.ZERO
			velocity.y = -800
		hurting = true
		damaged = true

		$HitPauseTimer.start()
		
		# plays sound when hit
		$hitHurt.play()
		
		sprite.frame = 0
		if GameSwitches.health <= 0:
			BackgroundMusic.playing = false
	sprite.animation = "hit"
	

func _on_HitPauseTimer_timeout():
	get_tree().paused = false
	$RecoverTimer.start()

func _on_RecoverTimer_timeout():
	if GameSwitches.health <= 0:
		GameSwitches.state = GameSwitches.DED
	else:
		GameSwitches.state = GameSwitches.REVIVE
	hurting = false
	
""""""

"""DED STATE ----------------------------------------------------------------"""
func ded():
	velocity = Vector2.ZERO
	sprite.animation = "ded"
	if dead == false:
		$deadDie.play()
		dead = true
		gravity = 0
	
	collision_mask = GameSwitches.no_collision
	collision_layer = GameSwitches.no_collision
	
	yield(sprite, "animation_finished")
	if sprite.animation == "ded":
		emit_signal("ded")
""""""

"""ATTACK STATE -------------------------------------------------------------"""
"""
when you attack on the ground,
	you stand still
	you can charge your attack
		but if you release early you do a normal attack
	once it's charged, you can change direction
	and when you release the attack button,
	create a string swoosh!
When you attack in the air,
	create a swoosh once
	
"""

func attack():
	if has_jumped == true and in_the_air == false:
		GameSwitches.state = GameSwitches.NORMAL
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
				# Plays the animation once so it doesnt repeat itself
				if attacking == false:
					sprite.animation = "attack"
					$swingSwipe.pitch_scale = rand_range(0.8, 1.2)
					$swingSwipe.volume_db = rand_range(-7, -5)
					$swingSwipe.play()
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
			
			# if you held dwon the attack button the whole time
			if charging_attack == true:
				charged_up = true
				charging_attack = false
				GameSwitches.state = GameSwitches.ATTACK
				
		# now you have your charge!
		elif charged_up == true:
			if attacking == false:
				sprite.animation = "charged"
			determine_direction()
			if Input.is_action_just_released("attack"):
				if attacking == false:
					create_swoosh()
					sprite.animation = "ground_swoosh_attack"
					$swingSwipe2.play()
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
		# makes swoosh once
		if attacking == false:
			create_swoosh()
			$swingSwipe.pitch_scale = rand_range(0.8, 1.2)
			$swingSwipe.volume_db = rand_range(-7, -5)
			$swingSwipe.play()
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
	
	if charged_up == true:
		air_swoosh.damage = 3
	else:
		air_swoosh.damage = 1
		
	if direction == "right":
		air_swoosh.position = $SwooshRight.global_position
		air_swoosh.speed = 1000
	elif direction == "left":
		air_swoosh.get_node("Sprite").flip_h = true
		air_swoosh.position = $SwooshLeft.global_position
		air_swoosh.speed = -1000
	get_parent().add_child(air_swoosh)


# similar to the air_swoosh, it uses a ray to determine where to make the hit sparkle
func _on_Sword_body_entered(body):
	# grab the state of the 2d world
	var space_state = get_world_2d().direct_space_state
	
	# create a ray that starts at the sword's global position and goes to the enemy's global position
	# the array at the end is what it will not intersect - the assassin
	var result = space_state.intersect_ray($Sword.global_position, body.global_position, [self])
	# result is now filled with information about where the ray intersected something
	
	var hit_sparkle = hit_sparkle_scene.instance()
	
	# we now can make it so the position of the hit_sparkle is at the location where the ray hit something
	hit_sparkle.position = result.position
	get_parent().add_child(hit_sparkle)
	
	# hurt the enemy by 1 point
	if body.get_parent() is PathFollow2D:
		body.deplete_health(1)
""""""

# when reviving, you're invulnerable
"""REVIVE STATE -------------------------------------------------------------"""
func revive(delta):
	gravity = 2300
	$AnimationPlayer.play("recover")
	normal(delta)
	yield($AnimationPlayer, "animation_finished")
	
	# enables collision again for the assassin
	damaged = false
	GameSwitches.state = GameSwitches.NORMAL
	collision_layer = GameSwitches.player_layer


func _on_Bottomless_Pit_body_entered(body):
	GameSwitches.health = 0
	BackgroundMusic.playing = false
	GameSwitches.state = GameSwitches.DED

func _on_BounceDelay_timeout():
	charged_up = false
	charging_attack = false
	GameSwitches.state = GameSwitches.NORMAL
	if collided_with_big_bouncepad == true:
		collided_with_big_bouncepad = false
		velocity.y = -2000
		velocity.x = 1250
		in_air()
		GameSwitches.state = GameSwitches.INACTIVE
	else:
		velocity.y = -1100
		can_jump = true
	gonna_jump_on_bounce_pad = false


func _on_VisibilityNotifier2D_screen_exited():
	if $Camera2D.current == false and GameSwitches.state != GameSwitches.INACTIVE:
		global_position = Vector2(53566.839844, 5569.997559)
		GameSwitches.state = GameSwitches.REVIVE
