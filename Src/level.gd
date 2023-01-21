extends Node

var dust_resource = preload("res://Scenes/dust.tscn")

func _ready():
	GameSwitches.assassin_spawnpoint = Vector2(200, 80)
	$Assassin.position = GameSwitches.assassin_spawnpoint
	
	BackgroundMusic.stream = Music.chip_joy
	BackgroundMusic.playing = true

func _physics_process(delta):
	if Input.is_action_pressed("flip"):
		GameSwitches.gonna_flip = true
	
	if GameSwitches.gonna_flip == true:
		do_a_flip()

func do_a_flip():
	if Input.is_action_just_released("flip"):
		if GameSwitches.flipped == false:
			$"Level Terrain".collision_mask = 0b0000
			$"Level Terrain Flip".collision_mask = 0b1101
			
			$"Level Terrain".hide()
			$"Level Terrain Flip".show()
			GameSwitches.flipped = true
		else:
			$"Level Terrain Flip".collision_mask = 0b0000
			$"Level Terrain".collision_mask = 0b1101
			
			$"Level Terrain".show()
			$"Level Terrain Flip".hide()
			GameSwitches.flipped = false
		GameSwitches.gonna_flip = false

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
