extends Area2D

class_name ToggleCamera
onready var camera = get_node("/root/Level/Assassin/Camera2D")
onready var tween = get_node("/root/Level/Assassin/Change Camera Zoom")

func _on_ToggleCamera_body_entered(body):
	set_camera_zoom(Vector2(1.5, 1.5), 0.5, Vector2(1.25, 1.25), 0.5, body)

func set_camera_zoom(left_zoom: Vector2, left_time: float, right_zoom: Vector2, right_time: float, body):
	# Left
	if body.global_position < global_position:
		zoom_camera(left_zoom, left_time)
	# Right
	elif body.global_position > global_position:
		zoom_camera(right_zoom, right_time)

func zoom_camera(zoom: Vector2, time: float):
	tween.interpolate_property(camera, "zoom", camera.zoom, zoom, time, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()
