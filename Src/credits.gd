extends Node


func _ready():
	BackgroundMusic.stream = Music.credit_samba
	BackgroundMusic.playing = true
	
func disco_lights():
	$DiscoMode/AnimatedSprite.frame = 0; $DiscoMode/AnimatedSprite.playing = true
	$DiscoMode/AnimatedSprite2.frame = 1; $DiscoMode/AnimatedSprite2.playing = true
	$DiscoMode/AnimatedSprite3.frame = 2; $DiscoMode/AnimatedSprite3.playing = true
	$DiscoMode/AnimatedSprite4.frame = 3; $DiscoMode/AnimatedSprite4.playing = true
	$DiscoMode/AnimatedSprite5.frame = 4; $DiscoMode/AnimatedSprite5.playing = true
	$DiscoMode/AnimatedSprite6.frame = 5; $DiscoMode/AnimatedSprite6.playing = true
	$DiscoMode/AnimatedSprite7.frame = 6; $DiscoMode/AnimatedSprite7.playing = true
	$DiscoMode/AnimatedSprite8.frame = 7; $DiscoMode/AnimatedSprite8.playing = true

func _on_Main_Menu_pressed():
	$clickChoose.playing = true
	yield($clickChoose, "finished")
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), 0)
	get_tree().change_scene("res://Scenes/menu.tscn")


func _on_Main_Menu_mouse_entered():
	$changeSwitch.play()


func _on_HiddenBtn_pressed():
	BackgroundMusic.stream = Music.disco_mode
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), 10)
	BackgroundMusic.playing = true
	$CreditLabel.hide()
	$HiddenBtn.hide()
	disco_lights()
	$DiscoMode.show()
