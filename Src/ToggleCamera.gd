extends Area2D

class_name ToggleCamera
onready var camera = get_node("/root/Level/Assassin/Camera2D")
onready var tween = get_node("/root/Level/Assassin/Change Camera Zoom")

func _on_ToggleCamera_body_entered(body):
	# Left
	if body.global_position < global_position:
		zoom_camera(Vector2(1.5, 1.5), 0.5)
	# Right
	elif body.global_position > global_position:
		zoom_camera(Vector2(1.25, 1.25), 0.5)

func zoom_camera(zoom: Vector2, time: float):
	tween.interpolate_property(camera, "zoom", camera.zoom, zoom, time, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()
