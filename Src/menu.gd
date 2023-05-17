extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$VBoxContainer/NewGame.grab_focus()
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), 0)
	BackgroundMusic.stream = Music.here_go
	BackgroundMusic.playing = true

func _process(delta):
	if Input.is_action_just_pressed("ui_pause"):
		$CanvasLayer/Options.hide()

func _on_NewGame_pressed():
	$clickChoose.playing = true
	BackgroundMusic.playing = false
	$Select.playing = true
	yield($Select, "finished")
	$SceneTransitionRect.transition_to("res://Scenes/level.tscn")


func _on_Continue_pressed():
	$clickChoose.playing = true
	BackgroundMusic.playing = false
	$Select.playing = true
	yield($Select, "finished")
	$SceneTransitionRect.transition_to("res://Scenes/level.tscn")


func _on_Quit_pressed():
	$clickChoose.playing = true
	yield($clickChoose, "finished")
	BackgroundMusic.playing = false
	get_tree().quit()


func _on_Options_pressed():
	$clickChoose.playing = true
	yield($clickChoose, "finished")
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), -5)
	$CanvasLayer/Options.show()


func _on_Credits_pressed():
	$clickChoose.playing = true
	yield($clickChoose, "finished")
	BackgroundMusic.playing = false
	$SceneTransitionRect.transition_to("res://Scenes/Credits.tscn")


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


