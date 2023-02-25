extends Node


func _ready():
	BackgroundMusic.stream = Music.credit_samba
	BackgroundMusic.playing = true


func _on_Main_Menu_pressed():
	$clickChoose.playing = true
	yield($clickChoose, "finished")
	get_tree().change_scene("res://Scenes/menu.tscn")


func _on_Main_Menu_mouse_entered():
	$changeSwitch.play()
