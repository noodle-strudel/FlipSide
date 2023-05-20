extends StaticBody2D

var broke = false


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
	broke = true
	$RecoverTimer.start()



func _on_RecoverTimer_timeout():
	if broke:
		$AnimationPlayer.play_backwards("break")
		set_collision_layer_bit(1, true)
		set_collision_mask_bit(0, true)
		set_collision_mask_bit(3, true)
		broke = false
