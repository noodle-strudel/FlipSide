extends StaticBody2D


var _speed = 100

onready var path_follow = get_parent()
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	path_follow.offset += _speed * delta
