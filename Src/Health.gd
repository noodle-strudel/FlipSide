extends Area2D



func _on_Health_body_entered(body):
	set_deferred("monitoring", false)
	GameSwitches.health += 1
	$healthUp.play()
	hide()
	yield($healthUp, "finished")
	queue_free()
