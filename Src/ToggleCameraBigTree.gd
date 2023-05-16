extends ToggleCamera

func _on_ToggleCameraBigTree_body_entered(body):
	zoom_camera(Vector2(1.75, 1.75), 0.7)


func _on_ToggleCameraBigTree_body_exited(body):
	zoom_camera(Vector2(1.25, 1.25), 0.5)
