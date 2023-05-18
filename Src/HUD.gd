extends Control

signal respawn
signal to_main_menu
	
func _process(delta):
	$RichTextLabel.bbcode_text = "Heath: " + str(GameSwitches.health) + "\n" + "Coins: " + str(GameSwitches.coins)

func _on_Button_pressed():
	$clickChoose.playing = true
	BackgroundMusic.playing = false
	emit_signal("respawn")

func _on_Menu_pressed():
	$clickChoose.playing = true
	BackgroundMusic.playing = false
	$Select.playing = true
	$Retry/VBoxContainer/Retry.disabled = true
	yield($Select, "finished")
	emit_signal("to_main_menu")
