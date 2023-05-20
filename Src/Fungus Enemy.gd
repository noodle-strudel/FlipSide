extends StaticBody2D

onready var path_follow = get_parent()
onready var coin = preload("res://Scenes/Coin.tscn")

export var _speed = 100

var hit_point = 3

var hit = false
var defeated = false
var dropped_coin = false

func _ready():
	if GameSwitches.flipped == true:
		$AnimatedSprite.play("flip")  
	else: 
		$AnimatedSprite.play("noflip")
	
func _physics_process(delta):
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
		collision_layer = 0
		collision_mask = 0
		defeated = true
		$TrueEnemyArea.monitoring = false
		hide()


func _on_TrueEnemyArea_body_entered(body):
	GameSwitches.state = GameSwitches.HIT

func deplete_health(health):
	$hitHurt.play()
	hit_point -= health
	hit = true
	$AnimatedSprite.playing = false
	$HitTimer.start()
	

func _on_HitTimer_timeout():
	hit = false
	$AnimatedSprite.playing = true


func flip():
	if $AnimatedSprite.animation == "noflip":
		$AnimatedSprite.play("flip")
		$TrueEnemyArea.monitoring = true
	else:
		$AnimatedSprite.play("noflip")
		$TrueEnemyArea.monitoring = false
		


func _on_VisibilityNotifier2D_screen_exited():
	if defeated:
		if GameSwitches.flipped:
			$TrueEnemyArea.monitoring = true
		else:
			$TrueEnemyArea.monitoring = false
		set_collision_layer_bit(2, true)
		set_collision_mask_bit(3, true) 
		set_collision_mask_bit(4, true)
		set_collision_mask_bit(0, true)
		hit_point = 3
		defeated = false
		show()
