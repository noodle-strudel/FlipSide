extends ToggleCamera

signal fall_scene

func _on_ToggleCameraFall_body_entered(body):
	Music.fade_music()
	emit_signal("fall_scene", "falling")
	zoom_camera(Vector2(2, 2), 1)

func _on_ToggleCameraFall_body_exited(body):
	Music.change_music(Music.switcharoo)
	emit_signal("fall_scene", "landing")
	zoom_camera(Vector2(1.5, 1.5), 1)
