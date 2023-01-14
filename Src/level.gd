extends Node

signal hit
var dust_resource = preload("res://Scenes/dust.tscn")

func _ready():
	pass 

func _on_Assassin_jumped():
	var dust = dust_resource.instance()
	dust.position = $Assassin.position
	dust.get_node("dust").animation = "before_jump"
	add_child(dust)

func _on_assassin_touch_floor():
	var dust = dust_resource.instance()
	dust.position = $Assassin.position
	dust.get_node("dust").animation = "landing"
	add_child(dust)

func _on_Assassin_ded():
	$CanvasLayer/HUD/Retry.show()

