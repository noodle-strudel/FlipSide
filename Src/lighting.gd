extends Node2D

func _ready():
	 GlobalSettings.connect("brightness_updated", self, "_change_brightness")


func _change_brightness(value):
	if value >= 0:
		$Light2D.color = Color(1, 1, 1, 1 )
		$Light2D.mode = Light2D.MODE_ADD
		$Light2D.energy = value/10
	else:
		$Light2D.color = Color(0, 0, 0, 1 )
		$Light2D.mode = Light2D.MODE_MIX
		$Light2D.energy = (value*-1)/10
