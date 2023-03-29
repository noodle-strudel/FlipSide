extends Node

signal brightness_updated(value)


# Video Settings
func toggle_fullscreen(value):
	OS.window_fullscreen = value

func change_brightness(value):
	emit_signal("brightness_updated", value)


# Audio Settings
func change_master_vol(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("FalseMaster"), value)
	
func change_music_vol(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), value)
	
func change_SFX_vol(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), value)
