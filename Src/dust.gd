extends Node2D

func _ready():
	$dust.frame = 0
	$dust.playing = true

func _on_dust_animation_finished():
	queue_free()
