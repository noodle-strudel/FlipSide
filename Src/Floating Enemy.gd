extends StaticBody2D

onready var path_follow = get_parent()
onready var coin = preload("res://Scenes/Coin.tscn")

export var _speed = 100
export var hit_point = 3
var defeated = false
var dropped_coin = false

func _ready():
	pass
	
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
		collision_layer = 0
		collision_mask = 0
		defeated = true
		hide()


func deplete_health(health):
	if $AnimatedSprite.animation == "noflip":
		$hitHurt.play()
		$AnimatedSprite.play("hurt")
		hit_point -= health
		$HitTimer.start()

func _on_HitTimer_timeout():
	$AnimatedSprite.play("noflip")

func flip():
	if $AnimatedSprite.animation == "noflip":
		$AnimatedSprite.play("flip")
		collision_layer = GameSwitches.enemy_layer
	else:
		$AnimatedSprite.play("noflip")
		collision_layer = GameSwitches.pass_through_layer


func _on_VisibilityNotifier2D_screen_exited():
	if defeated:
		if GameSwitches.flipped:
			set_collision_layer_bit(2, true)
		else:
			set_collision_layer_bit(7, true)
		set_collision_mask_bit(3, true) 
		set_collision_mask_bit(4, true)
		hit_point = 3
		defeated = false
		show()
