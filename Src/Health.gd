extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_Health_body_entered(body):
	GameSwitches.health += 1
	$healthUp.play()
	hide()
	yield($healthUp, "finished")
	queue_free()
