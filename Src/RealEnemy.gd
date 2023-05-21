extends StaticBody2D


var _speed = 100

onready var path_follow = get_parent()


func _physics_process(delta):
	path_follow.offset += _speed * delta
