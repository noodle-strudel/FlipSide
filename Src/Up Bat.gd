extends StaticBody2D

onready var path_follow = get_parent()

export var _speed = 300

var flying_down = false
var flying_up = false

signal spawn_crystal

func _ready():
	pass
	
func _physics_process(delta):
	if flying_down == true:
		fly_down(delta)
	elif flying_up == true:
		fly_up(delta)


func deplete_health(health):
	pass

func fly_down(delta):
	path_follow.offset += _speed * delta
	if path_follow.unit_offset == 1:
		flying_down = false
		
func fly_up(delta):
	path_follow.offset -= _speed * delta
	if path_follow.unit_offset == 0:
		flying_down = false

func flip():
	if $AnimatedSprite.animation == "noflip":
		$CollisionShape2D.shape.extents = Vector2(40, 26)
		$CollisionShape2D.position = Vector2(0, 14)
		$AnimatedSprite.play("flip")
	else:
		$CollisionShape2D.shape.extents = Vector2(40, 44)
		$CollisionShape2D.position = Vector2(0, -4)
		$AnimatedSprite.play("noflip")
	
