extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$dust.frame = 0
	$dust.playing = true

func _on_dust_animation_finished():
	queue_free()
