extends StaticBody2D

onready var path_follow = get_parent()

export var _speed = 100

export var hit_point = 3

func _ready():
	pass
	
func _physics_process(delta):
	path_follow.offset += _speed * delta
	
	if hit_point <= 0:
		yield($hitHurt, "finished")
		queue_free()


func deplete_health(health):
	$hitHurt.play()
	hit_point -= health

