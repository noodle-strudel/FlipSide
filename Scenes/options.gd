extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _on_MasterVolSlider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("FalseMaster"), value)
	$TabContainer/Audio/VBoxContainer/HBoxContainer/MasVolValue.text = str(value+40)
	
func _on_MusicVolSlider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), value)
	$TabContainer/Audio/VBoxContainer/HBoxContainer2/MusicVolValue.text = str(value+40)
	
func _on_SFXVolSlider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), value)
	$TabContainer/Audio/VBoxContainer/HBoxContainer3/SFXVolValue.text = str(value+40)

func _on_Main_Menu_pressed():
	$clickChoose.playing = true
	yield($clickChoose, "finished")
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), 0)
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



func _on_Reset_pressed():
	if $TabContainer.current_tab == 1:
		$TabContainer/Audio/VBoxContainer/HBoxContainer/MasterVolSlider.value = 0
		$TabContainer/Audio/VBoxContainer/HBoxContainer2/MusicVolSlider.value = 0
		$TabContainer/Audio/VBoxContainer/HBoxContainer3/SFXVolSlider.value = 0
