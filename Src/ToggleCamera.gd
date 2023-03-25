extends Area2D

class_name ToggleCamera

onready var camera = get_node("/root/Level/Assassin/Camera2D")
onready var tween = get_node("/root/Level/Assassin/Change Camera Zoom")

func zoom_camera(zoom: Vector2, time: float):
	print("triggered")
	tween.interpolate_property(camera, "zoom", camera.zoom, zoom, time, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()

func _on_ToggleCameraLeftHealth_body_entered(body):
	zoom_camera(Vector2(1.5, 1.5), 0.5)


func _on_ToggleCameraLeftHealth_body_exited(body):
	zoom_camera(Vector2(1.25, 1.25), 0.5)
