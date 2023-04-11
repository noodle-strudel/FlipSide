extends ToggleCamera


func _on_ToggleCameraRightHealth_body_entered(body):
	# Left
	if body.global_position < global_position:
		zoom_camera(Vector2(1.25, 1.25), 0.5)
	# Right
	elif body.global_position > global_position:
		zoom_camera(Vector2(1.5, 1.5), 0.5)
