extends Area2D

onready var camera = get_node("/root/Tutorial Level/Assassin/Camera2D")
onready var tween = get_node("/root/Tutorial Level/Assassin/Change Camera Zoom")

func zoom_camera(zoom: Vector2, time: float):
	tween.interpolate_property(camera, "zoom", camera.zoom, zoom, time, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()
	
func _on_ToggleCameraTutorial_body_entered(body):
	print(body)
	zoom_camera(Vector2(1.75, 1.75), 0.7)


func _on_ToggleCameraTutorial_body_exited(body):
	zoom_camera(Vector2(1.25, 1.25), 0.5)
