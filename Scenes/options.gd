extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _process(delta):
	if Input.is_action_pressed("ui_pause"):
		hide()

# Video Settings
func _on_DisplayModeButton_item_selected(index):
	GlobalSettings.toggle_fullscreen(true if index == 1 else false)

func _on_BrightnessSlider_value_changed(value):
	GlobalSettings.change_brightness(value)
	$TabContainer/Video/MarginContainer/VBoxContainer/HBoxContainer/BrightnessValue.text = str(value)


# Audio Settings
func _on_MasterVolSlider_value_changed(value):
	GlobalSettings.change_master_vol(value)
	$TabContainer/Audio/VBoxContainer/HBoxContainer/MasVolValue.text = str(value+40)
	
func _on_MusicVolSlider_value_changed(value):
	GlobalSettings.change_music_vol(value)
	$TabContainer/Audio/VBoxContainer/HBoxContainer2/MusicVolValue.text = str(value+40)
	
func _on_SFXVolSlider_value_changed(value):
	GlobalSettings.change_SFX_vol(value)
	$TabContainer/Audio/VBoxContainer/HBoxContainer3/SFXVolValue.text = str(value+40)


# Non-settings
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


# Reset Button
func _on_Reset_pressed():
	if $TabContainer.current_tab == 1:
		$TabContainer/Audio/VBoxContainer/HBoxContainer/MasterVolSlider.value = 0
		$TabContainer/Audio/VBoxContainer/HBoxContainer2/MusicVolSlider.value = 0
		$TabContainer/Audio/VBoxContainer/HBoxContainer3/SFXVolSlider.value = 0
	elif $TabContainer.current_tab == 0:
		$TabContainer/Video/MarginContainer/VBoxContainer/HBoxContainer/BrightnessSlider.value = 0



