extends ToggleCamera


func _on_ToggleCameraFlipper_body_entered(body):
	zoom_camera(Vector2(2, 2), 1)


func _on_ToggleCameraFlipper_body_exited(body):
	zoom_camera(Vector2(1.25, 1.25), 1)
