extends Area2D


func _ready():
	pass # Replace with function body.

func _on_Flipper_body_entered(body):
	if get_parent().name != "To Castle":
		GameSwitches.can_flip = true
		$flipFlop.play()
		$ominousNoise.playing = false
		hide()
		yield($flipFlop, "finished")
		queue_free()
	
