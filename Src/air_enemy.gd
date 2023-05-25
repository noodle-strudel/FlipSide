extends StaticBody2D
class_name air_enemy

onready var path_follow = get_parent()
onready var coin = preload("res://Scenes/Coin.tscn")
onready var health_bar = preload("res://Scenes/HealthBar.tscn")
onready var assassin = get_tree().get_current_scene().get_node("Assassin")

export var _speed = 100
var hit_point = 3
var defeated = false
var dropped_coin = false
var no_health_bar = true

func _ready():
	if GameSwitches.assassin_spawnpoint.x > global_position.x:
		dropped_coin = true
	if get_tree().root.get_child(6).name == "Castle":
		_speed = 200
	if GameSwitches.flipped == true:
		flip()
	
func _physics_process(delta):
	path_follow.offset += _speed * delta
	if path_follow.unit_offset > 0.5:
		$AnimatedSprite.flip_h = false
	else:
		$AnimatedSprite.flip_h = true
	
	if hit_point <= 0 and defeated == false:
		if dropped_coin == false:
			var coin_instance = coin.instance()
			coin_instance.global_position = global_position
			get_tree().get_current_scene().add_child(coin_instance)
			dropped_coin = true
		
		hit_point = 0
		yield($hitHurt, "finished")
		flinch_timeout()
		collision_layer = 0
		collision_mask = 0
		defeated = true
		hide()

func deplete_health(damage):
	if name == "Flying Enemy":
		if damage != 3:
			configure_health_bar()
			$HealthBar/ProgressBar.value -= 1
		$hitHurt.play()
		hit_point -= damage
	elif name == "Floating Enemy":
		if $AnimatedSprite.animation == "noflip":
			if damage != 3:
				configure_health_bar()
				$HealthBar/ProgressBar.value -= 1
				$HealthBar/ProgressBar.get_stylebox("fg").bg_color = Color.gray
			$hitHurt.play()
			$AnimatedSprite.play("hurt")
			hit_point -= damage
			$HitTimer.start()
			
		else:
			if no_health_bar == true:
				configure_health_bar()
				$HealthBar/ProgressBar.get_stylebox("fg").bg_color = Color.gray
			$cloudReflect.play()

func configure_health_bar():
	# if the enemy is hit for the first time, instance a health bar above them
	# if they already have a health bar, don't make a new one!
	var health_bar_instance = health_bar.instance()
	for child in get_children():
		if child.name == "HealthBar":
			no_health_bar = false
	if no_health_bar:
		add_child(health_bar_instance)
	$HealthBar.show()

# Use with HitTimer
func flinch_timeout():
	
	if GameSwitches.flipped == false:
		$HealthBar/ProgressBar.get_stylebox("fg").bg_color = Color.red
		$AnimatedSprite.play("noflip")
	else:
		$AnimatedSprite.play("flip")
		$HealthBar/ProgressBar.get_stylebox("fg").bg_color = Color.gray

func flip():
	if name == "Flying Enemy":
		if $AnimatedSprite.animation == "noflip":
			$CollisionShape2D.shape.extents = Vector2(40, 26)
			$CollisionShape2D.position = Vector2(0, 14)
			$AnimatedSprite.play("flip")
		else:
			$CollisionShape2D.shape.extents = Vector2(40, 44)
			$CollisionShape2D.position = Vector2(0, -4)
			$AnimatedSprite.play("noflip")
	
	elif name == "Floating Enemy":
		if $AnimatedSprite.animation == "noflip" or $AnimatedSprite.animation == "hurt":
			$AnimatedSprite.play("flip")
			if no_health_bar == false:
				$HealthBar/ProgressBar.get_stylebox("fg").bg_color = Color.gray
			if not defeated:
				collision_layer = GameSwitches.enemy_layer
		else:
			$AnimatedSprite.play("noflip")
			if no_health_bar == false:
				$HealthBar/ProgressBar.get_stylebox("fg").bg_color = Color.red
			if not defeated:
				collision_layer = GameSwitches.pass_through_layer

# Use with VisibilityNotifier
func respawn():
	if defeated:
		if name == "Flying Enemy":
			set_collision_layer_bit(2, true)
			set_collision_mask_bit(3, true) 
			set_collision_mask_bit(4, true)
			set_collision_mask_bit(0, true)
		elif name == "Floating Enemy":
			if GameSwitches.flipped:
				set_collision_layer_bit(2, true)
			else:
				set_collision_layer_bit(7, true)
			set_collision_mask_bit(3, true) 
			set_collision_mask_bit(4, true)
		
		hit_point = 3
		defeated = false
		# if there's a healthbar, the bar fills up
		if no_health_bar == false:
			$HealthBar/ProgressBar.value = 3
			$HealthBar.hide()
		show()
