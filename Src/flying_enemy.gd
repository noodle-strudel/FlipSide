extends StaticBody2D

onready var path_follow = get_parent()
onready var coin = preload("res://Scenes/Coin.tscn")

export var _speed = 100

export var hit_point = 3
var defeated = false
var dropped_coin = false

func _ready():
	if get_tree().root.get_child(6).name == "Castle":
		_speed = 200
	
func _physics_process(delta):
	path_follow.offset += _speed * delta
	
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
		hide()


func deplete_health(health):
	$hitHurt.play()
	hit_point -= health

func flip():
	if $AnimatedSprite.animation == "noflip":
		$CollisionShape2D.shape.extents = Vector2(40, 26)
		$CollisionShape2D.position = Vector2(0, 14)
		$AnimatedSprite.play("flip")
	else:
		$CollisionShape2D.shape.extents = Vector2(40, 44)
		$CollisionShape2D.position = Vector2(0, -4)
		$AnimatedSprite.play("noflip")


func _on_VisibilityNotifier2D_screen_exited():
	if defeated:
		set_collision_layer_bit(2, true)
		set_collision_mask_bit(3, true) 
		set_collision_mask_bit(4, true)
		set_collision_mask_bit(0, true)
		hit_point = 3
		show()
