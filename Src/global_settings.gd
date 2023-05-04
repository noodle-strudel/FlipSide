extends Node

signal brightness_updated(value)


# Video Settings
func toggle_fullscreen(value):
	OS.window_fullscreen = value
	Save.game_data.fullscreen = value
	Save.save_data()

func change_brightness(value):
	emit_signal("brightness_updated", value)
	Save.game_data.brightness = value
	Save.save_data()


# Audio Settings
func change_master_vol(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("FalseMaster"), value)
	Save.game_data.master_vol = value
	Save.save_data()
	
func change_music_vol(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), value)
	Save.game_data.music_vol = value
	Save.save_data()
	
func change_SFX_vol(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), value)
	Save.game_data.SFX_vol = value
	Save.save_data()
