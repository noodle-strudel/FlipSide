extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Flipper_body_entered(body):
	GameSwitches.can_flip = true
	$flipFlop.play()
	$ominousNoise.playing = false
	hide()
	yield($flipFlop, "finished")
	queue_free()
	
