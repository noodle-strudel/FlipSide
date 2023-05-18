extends Control

# Function that doesn't work :(
func select_option():
	BackgroundMusic.playing = false
	$Select.playing = true
	yield($Select, "finished")

# Called when the node enters the scene tree for the first time.
func _ready():
	$VBoxContainer/NewGame.grab_focus()
	BackgroundMusic.stream = Music.here_go
	BackgroundMusic.playing = true

func _on_NewGame_pressed():
	$clickChoose.playing = true
	BackgroundMusic.playing = false
	$Select.playing = true
	yield($Select, "finished")
	get_tree().change_scene("res://Scenes/level.tscn")


func _on_Continue_pressed():
	$clickChoose.playing = true
	BackgroundMusic.playing = false
	$Select.playing = true
	yield($Select, "finished")
	get_tree().change_scene("res://Scenes/level.tscn")


func _on_Quit_pressed():
	$clickChoose.playing = true
	yield($clickChoose, "finished")
	BackgroundMusic.playing = false
	get_tree().quit()


func _on_Options_pressed():
	$clickChoose.playing = true
	yield($clickChoose, "finished")
	BackgroundMusic.volume_db -= 10
	$CanvasLayer/Options.show()


# Makes a noise when hovered over
func _on_NewGame_mouse_entered():
	$changeSwitch.play()
	
func _on_Continue_mouse_entered():
	$changeSwitch.play()

func _on_Quit_mouse_entered():
	$changeSwitch.play()
	
func _on_Options_mouse_entered():
	$changeSwitch.play()

func _on_Credits_mouse_entered():
	$changeSwitch.play()
