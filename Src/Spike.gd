extends StaticBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func flip():
	if GameSwitches.flipped == true:
		$AnimationPlayer.play("to_bounce_pad")
	else:
		$AnimationPlayer.play("to_spike")
