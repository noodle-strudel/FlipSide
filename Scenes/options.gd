extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _on_Main_Menu_pressed():
	$clickChoose.playing = true
	yield($clickChoose, "finished")
	BackgroundMusic.volume_db += 10
	visible = false
	
func _on_Video_tab_clicked():
	$clickChoose.playing = true
	yield($clickChoose, "finished")

func _on_Audio_tab_clicked():
	$clickChoose.playing = true
	yield($clickChoose, "finished")

func _on_Gameplay_tab_clicked():
	$clickChoose.playing = true
	yield($clickChoose, "finished")

	
# Makes a noise when hovered over
func _on_Video_tab_hover(tab):
	$changeSwitch.play()
	
func _on_Audio_tab_hover(tab):
	$changeSwitch.play()

func _on_Gameplay_tab_hover(tab):
	$changeSwitch.play()
	
func _on_Main_Menu_mouse_entered():
	$changeSwitch.play()

