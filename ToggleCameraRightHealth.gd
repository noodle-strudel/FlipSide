extends ToggleCamera


func _on_ToggleCameraRightHealth_body_entered(body):
	if body.global_position < global_position:
		zoom_camera(Vector2(1.25, 1.25), 1)
