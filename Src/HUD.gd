extends Control

signal respawn
signal to_main_menu
	
func _process(delta):
	$RichTextLabel.bbcode_text = "Health: " + str(GameSwitches.health) + "\n\n" + "Coins: " + str(GameSwitches.coins)
	
	if Input.is_action_just_pressed("ui_pause"):
		if $Options.visible == true:
			get_tree().paused = false
			$Options.visible = false
		else:
			get_tree().paused = true
			$Options.visible = true

func _on_Button_pressed():
	$clickChoose.playing = true
	BackgroundMusic.playing = false
	emit_signal("respawn")
	GameSwitches.emit_signal("respawn_coins")

func _on_Menu_pressed():
	GameSwitches.flipped = false
	$clickChoose.playing = true
	BackgroundMusic.playing = false
	$Select.playing = true
	$Retry/VBoxContainer/Retry.disabled = true
	yield($Select, "finished")
	emit_signal("to_main_menu")
