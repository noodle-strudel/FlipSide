extends Node

var dust_resource = preload("res://Scenes/dust.tscn")

func _ready():
	GameSwitches.assassin_spawnpoint = Vector2(200, 80)
	$Assassin.position = GameSwitches.assassin_spawnpoint
	
	BackgroundMusic.stream = Music.chip_joy
	BackgroundMusic.playing = true

func _on_Assassin_jumped():
	pass

func _on_assassin_touch_floor():
	var dust = dust_resource.instance()
	dust.position = $Assassin.position
	dust.get_node("dust").animation = "landing"
	add_child(dust)

func _on_Assassin_ded():
	$CanvasLayer/HUD/Retry.show()


func _on_Assassin_air_jumped():
	var dust = dust_resource.instance()
	dust.position = $Assassin.position
	dust.get_node("dust").animation = "before_jump"
	add_child(dust)


func _on_HUD_respawn():
	$Assassin.position = GameSwitches.assassin_spawnpoint
	GameSwitches.state = GameSwitches.NORMAL
	GameSwitches.health = 3
	$Assassin.dead = false
	$CanvasLayer/HUD/Retry.hide()
