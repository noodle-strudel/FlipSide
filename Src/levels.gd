extends Node
class_name level

var dust_resource = preload("res://Scenes/dust.tscn")

var flip_original = preload("res://Assets/Tileset/real_tileset.png")
var flip_warp = preload("res://Assets/Tileset/flip tileset.png")

export var music: Resource

# Called when the node enters the scene tree for the first time.
func _ready():
	$Assassin.position = GameSwitches.assassin_spawnpoint
	Music.change_music(music)
	
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), 0)

func _physics_process(delta):
	if GameSwitches.can_flip:
		if Input.is_action_pressed("flip"):
			GameSwitches.gonna_flip = true
		
		if GameSwitches.gonna_flip == true:
			do_a_flip()

func do_a_flip(bypass = false):
	# Flips when they release the button
	if Input.is_action_just_released("flip") || bypass == true:
		$flipFlop.play()
		get_tree().call_group("enemy", "flip")
		if GameSwitches.flipped == false:
			$"Details Foreground".tile_set.tile_set_texture(0, flip_warp)
			if get_tree().get_current_scene().name != "Cave":
				$ParallaxBackground/Forest/ForestBackground.play("forestflip")
			GameSwitches.flipped = true
		else:
			$"Details Foreground".tile_set.tile_set_texture(0, flip_original)
			if get_tree().get_current_scene().name != "Cave":
				$ParallaxBackground/Forest/ForestBackground.play("forestnoflip")
			GameSwitches.flipped = false
		GameSwitches.gonna_flip = false

func create_land_dust():
	var dust = dust_resource.instance()
	dust.position = $Assassin.position
	dust.get_node("dust").animation = "landing"
	add_child(dust)

func die():
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), -5)
	Music.change_music(Music.you_died)
	$CanvasLayer/HUD/Retry.show()

func create_air_dust():
	var dust = dust_resource.instance()
	dust.position = $Assassin.position
	dust.get_node("dust").animation = "before_jump"
	add_child(dust)

func respawn():
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), 0)
	$Assassin.position = GameSwitches.assassin_spawnpoint
	GameSwitches.state = GameSwitches.REVIVE
	GameSwitches.load_data()
	
	$Assassin.dead = false
	
	# collision layer for the assassin comes back after they are revived
	
	# "|" adds binary numbers together
	$Assassin.collision_mask = GameSwitches.terrain_layer | GameSwitches.coin_layer
	
	$CanvasLayer/HUD/Retry.hide()
	Music.change_music(music)
