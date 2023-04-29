extends StaticBody2D


onready var path_follow = get_parent()

var speed = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	path_follow.offset += speed
