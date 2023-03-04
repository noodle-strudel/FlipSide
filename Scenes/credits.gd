extends Node


func _ready():
	BackgroundMusic.stream = Music.credit_samba
	BackgroundMusic.playing = true


func _on_Main_Menu_pressed():
	$clickChoose.playing = true
	yield($clickChoose, "finished")
	BackgroundMusic.volume_db = -20
	get_tree().change_scene("res://Scenes/menu.tscn")


func _on_Main_Menu_mouse_entered():
	$changeSwitch.play()


func _on_HiddenBtn_pressed():
	BackgroundMusic.stream = Music.disco_mode
	BackgroundMusic.volume_db += 12
	BackgroundMusic.playing = true
	$CreditLabel.hide()
	$HiddenBtn.hide()
	$DiscoMode.show()
