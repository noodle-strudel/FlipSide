extends StaticBody2D

onready var path_follow = get_parent()

export var _speed = 100

export var hit_point = 3

func _ready():
	pass
	
func _physics_process(delta):
	path_follow.offset += _speed * delta
	if path_follow.unit_offset > 0.5:
		$AnimatedSprite.flip_h = false
	else:
		$AnimatedSprite.flip_h = true
	
	if hit_point <= 0:
		yield($hitHurt, "finished")
		queue_free()


func _on_TrueEnemyArea_body_entered(body):
	GameSwitches.state = GameSwitches.HIT

func deplete_health(health):
	$hitHurt.play()
	hit_point -= health
