extends Node

signal hit
var dust_resource = preload("res://Scenes/dust.tscn")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	BackgroundMusic.stream = Music.chip_joy
	BackgroundMusic.playing = true


func _on_assassin_touch_floor():
	var dust = dust_resource.instance()
	dust.position = $Assassin.position
	add_child(dust)
