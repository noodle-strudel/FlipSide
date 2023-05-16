extends ToggleCamera

signal fall_scene

func _on_ToggleCameraFall_body_entered(body):
	emit_signal("fall_scene", "falling")
	zoom_camera(Vector2(2, 2), 1)

func _on_ToggleCameraFall_body_exited(body):
	emit_signal("fall_scene", "landing")
	zoom_camera(Vector2(1.25, 1.25), 1)
