extends StaticBody2D
class_name land_enemy

onready var path_follow = get_parent()
onready var coin = preload("res://Scenes/Coin.tscn")
onready var health_bar = preload("res://Scenes/HealthBar.tscn")
onready var assassin = get_tree().get_current_scene().get_node("Assassin")

# Initial Variables
export var _speed = 100
var hit_point = 3
var hit = false
var defeated = false
var dropped_coin = false
var no_health_bar = true

func _ready():
	if GameSwitches.assassin_spawnpoint.x > global_position.x:
		dropped_coin = true
	if GameSwitches.flipped == true:
		flip()

func _physics_process(delta):
	# if the true enemy area is overlapping with the assassin when they are not reviving,
	# hurt them
	if $TrueEnemyArea.overlaps_body(assassin) and GameSwitches.state != GameSwitches.REVIVE:
		GameSwitches.state = GameSwitches.HIT
	if $AnimationPlayer.current_animation == "bounce":
		revert()
	else:
		if hit == false:
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
			
			yield($hitHurt, "finished")
			flinch_timeout()
			collision_layer = 0
			collision_mask = 0
			defeated = true
			$TrueEnemyArea.monitoring = false
			hide()

func deplete_health(damage):
	if damage != 3:
		configure_health_bar()
		$HealthBar/ProgressBar.value -= 1
	$hitHurt.play()
	hit_point -= damage
	hit = true
	$AnimatedSprite.playing = false
	$HitTimer.start()

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
	hit = false
	$AnimatedSprite.playing = true
	$AnimatedSprite.frame += 1

func flip():
	if $AnimatedSprite.animation == "noflip":
		$AnimatedSprite.play("flip")
		if name == "Ground Enemy":
			$TrueEnemyArea.monitoring = false
		else:
			$TrueEnemyArea.monitoring = true
	else:
		$AnimatedSprite.play("noflip")
		if name == "Ground Enemy":
			$TrueEnemyArea.monitoring = true
		else:
			$TrueEnemyArea.monitoring = false

func revert():
	yield($AnimationPlayer, "animation_finished")
	if GameSwitches.flipped:
		$AnimatedSprite.play("flip")
	else:
		$AnimatedSprite.play("noflip")

# Use with a VisibilityNotifier
func respawn():
	if defeated:
		# make it so these are different in the respective bug or musrhoom scene
		if GameSwitches.flipped:
			if name == "Ground Enemy":
				$TrueEnemyArea.monitoring = false
			else:
				$TrueEnemyArea.monitoring = true
		else:
			if name == "Ground Enemy":
				$TrueEnemyArea.monitoring = true
			else:
				$TrueEnemyArea.monitoring = false
		set_collision_layer_bit(2, true)
		set_collision_mask_bit(3, true) 
		set_collision_mask_bit(4, true)
		set_collision_mask_bit(0, true)
		hit_point = 3
		# if there's a healthbar, the bar fills up
		if no_health_bar == false:
			$HealthBar/ProgressBar.value = 3
			$HealthBar.hide()
		defeated = false
		show()
