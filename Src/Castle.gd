extends Node2D

var dust_resource = preload("res://Scenes/dust.tscn")

var flip_original = preload("res://Assets/Tileset/real_tileset.png")
var flip_warp = preload("res://Assets/Tileset/flip tileset.png")

var got_a_ride = false

func _ready():
	GameSwitches.state = GameSwitches.INACTIVE
	GameSwitches.flipped = true
	get_tree().call_group("enemy", "flip")
	$"Details Foreground".tile_set.tile_set_texture(0, flip_warp)
	GameSwitches.save_data()
	Music.change_music(Music.chip_joy_loop)

func _physics_process(delta):
	if got_a_ride == false:
		if $"Flying Enemy Path/PathFollow2D".unit_offset == 1:
			GameSwitches.state = GameSwitches.NORMAL
			got_a_ride = true
	
	if GameSwitches.can_flip:
		if Input.is_action_pressed("flip"):
			GameSwitches.gonna_flip = true
		
		if GameSwitches.gonna_flip == true:
			do_a_flip()

func do_a_flip():
	# Blank for now until we want something special to happen while we hold down the flip button
	if GameSwitches.flipped == false:
		pass
		
	# Flips when they release the button
	if Input.is_action_just_released("flip"):
		get_tree().call_group("enemy", "flip")
		if GameSwitches.flipped == false:
			$"Details Foreground".tile_set.tile_set_texture(0, flip_warp)
			
			GameSwitches.flipped = true
		else:
			$"Details Foreground".tile_set.tile_set_texture(0, flip_original)
			
			GameSwitches.flipped = false
		GameSwitches.gonna_flip = false


func _on_Assassin_touch_floor():
	var dust = dust_resource.instance()
	dust.position = $Assassin.position
	dust.get_node("dust").animation = "landing"
	add_child(dust)

func _on_Assassin_ded():
	Music.change_music(Music.you_died)
	$CanvasLayer/HUD/Retry.show()

func _on_Assassin_air_jumped():
	var dust = dust_resource.instance()
	dust.position = $Assassin.position
	dust.get_node("dust").animation = "before_jump"
	add_child(dust)


func _on_HUD_respawn():
	$Assassin.position = GameSwitches.assassin_spawnpoint
	GameSwitches.state = GameSwitches.REVIVE
	GameSwitches.load_data()
	
	$Assassin.dead = false
	$Assassin.reviving = true
	
	# enables collision again for the assassin
	$Assassin.collision_layer = GameSwitches.player_layer
	
	# "|" adds binary numbers together
	$Assassin.collision_mask = GameSwitches.terrain_layer | GameSwitches.coin_layer
	
	$CanvasLayer/HUD/Retry.hide()
	Music.change_music(Music.chip_joy_loop)



func _on_Assassin_on_friendly_bat():
	# grab the state of the 2d world
	var space_state = get_world_2d().direct_space_state
	
	# create a ray that starts at the sword's global position and goes to the enemy's global position
	# the array at the end is what it will not intersect - the assassin
	var result = space_state.intersect_ray($Assassin.global_position, Vector2($Assassin.global_position.x, $Assassin.global_position.y + 2), [$Assassin])
	if result:
		$"Flying Enemy Path/PathFollow2D/RemoteTransform2D".global_position.x = $Assassin.global_position.x
		$"Flying Enemy Path/PathFollow2D/RemoteTransform2D".set_remote_node("../../../Assassin")
	else:
		$"Flying Enemy Path/PathFollow2D/RemoteTransform2D".set_remote_node("")



func _on_Assassin_jumped():
	$"Flying Enemy Path/PathFollow2D/RemoteTransform2D".set_remote_node("")


func _on_TriggerKing_body_entered(body):
	$Assassin.velocity = Vector2.ZERO
	GameSwitches.state = GameSwitches.INACTIVE
	$Assassin/AnimatedSprite.play("idle")
	$"Assassin/Change Camera Zoom".interpolate_property(
		$Assassin/Camera2D, "global_position", 
		$Assassin/Camera2D.global_position, Vector2(6336, $Assassin/Camera2D.global_position.y), 
		1.0, Tween.TRANS_SINE)
	yield(get_tree().create_timer(1.0), "timeout")
	$"Assassin/Change Camera Zoom".start()
