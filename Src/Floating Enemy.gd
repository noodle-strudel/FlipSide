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



