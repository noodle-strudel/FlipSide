extends Node2D

func _ready():
	$Sparkle.frame = 0
	$Sparkle.playing = true

func _on_Sparkle_animation_finished():
	queue_free()
