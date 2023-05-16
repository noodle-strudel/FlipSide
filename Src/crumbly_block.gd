extends StaticBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_body_entered(body):
	$CrumbleTimer.start(0)
	$AnimationPlayer.play("shake")


func _on_Area2D_body_exited(body):
	$CrumbleTimer.stop()
	$AnimationPlayer.play("RESET")


func _on_CrumbleTimer_timeout():
	$AnimationPlayer.play("break")
	collision_layer = 0
	collision_mask = 0
	yield(get_tree().create_timer(1), "timeout")
	queue_free()
