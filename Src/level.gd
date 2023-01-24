extends Node

var dust_resource = preload("res://Scenes/dust.tscn")

var terrain = preload("res://Assets/Tileset/DeepForestPackNA/Tileset/DeepForestTilesetTerrain.png")
var flip_original = preload("res://Assets/Tileset/DeepForestPackNA/Tileset/flip_original_world_tileset.png")
var flip_warp = preload("res://Assets/Tileset/DeepForestPackNA/Tileset/flip_warp_world_tileset.png")

func _ready():
	GameSwitches.assassin_spawnpoint = Vector2(200, 80)
	$Assassin.position = GameSwitches.assassin_spawnpoint
	
	BackgroundMusic.stream = Music.chip_joy
	BackgroundMusic.playing = false

func _physics_process(delta):
	if Input.is_action_pressed("flip"):
		GameSwitches.gonna_flip = true
	
	if GameSwitches.gonna_flip == true:
		do_a_flip()

func do_a_flip():
	if GameSwitches.flipped == false:
		$"Level Terrain Flip".tile_set.tile_set_texture(0, flip_warp)
		$"Level Terrain Flip".show()
	else:
		$"Level Terrain".tile_set.tile_set_texture(0, flip_original)
		$"Level Terrain".show()

	if Input.is_action_just_released("flip"):
		if GameSwitches.flipped == false:
			$"Level Terrain".collision_mask = 0b0000
			$"Level Terrain Flip".collision_mask = 0b1101
			$"Level Terrain Flip".tile_set.tile_set_texture(0, terrain)
			$"Level Terrain".hide()
			
			GameSwitches.flipped = true
		else:
			$"Level Terrain Flip".collision_mask = 0b0000
			$"Level Terrain".collision_mask = 0b1101
			$"Level Terrain".tile_set.tile_set_texture(0, terrain)
			
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
	GameSwitches.state = GameSwitches.REVIVE
	GameSwitches.health = 3
	$Assassin.dead = false
	$Assassin.reviving = true
	$CanvasLayer/HUD/Retry.hide()
