extends Control

signal respawn
signal to_main_menu

func _ready():
	$Retry.grab_focus()

func _process(delta):
	$RichTextLabel.bbcode_text = "Health: " + str(GameSwitches.health) + "\n\n" + "Coins: " + str(GameSwitches.coins)

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
