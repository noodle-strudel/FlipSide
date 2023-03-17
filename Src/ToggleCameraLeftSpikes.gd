extends ToggleCamera

func _on_ToggleCameraLeftSpikes_body_entered(body):
	set_camera_zoom(Vector2(1.5, 1.5), 0.5, Vector2(1.25, 1.25), 0.5, body)
