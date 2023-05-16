extends Control

signal respawn

func _ready():
	pass # Replace with function body.
	
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
	yield($Select, "finished")
	get_tree().change_scene("res://Scenes/menu.tscn")
