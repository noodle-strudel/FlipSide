extends Node

var dust_resource = preload("res://Scenes/dust.tscn")

var flip_original = preload("res://Assets/Tileset/real_tileset.png")
var flip_warp = preload("res://Assets/Tileset/flip tileset.png")
var going_out_of_cave = false

func _ready():
	GameSwitches.save_data()
	$Assassin/Camera2D.limit_bottom = 10000
	GameSwitches.assassin_spawnpoint = Vector2(52500, 5000)
	#33600 to go to the entrance of the cave or 200 to spawn at the start of the game
	$Assassin.position = GameSwitches.assassin_spawnpoint
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), 0)
  
	Music.change_music(Music.chip_joy_loop)
	

func _process(delta):
	if Input.is_action_just_pressed("ui_pause"):
		if $CanvasLayer/HUD/Options.visible == true:
			$CanvasLayer/HUD/Options.visible = false
		else:
			$CanvasLayer/HUD/Options.visible = true
		

func _physics_process(delta):
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

func _on_Assassin_jumped():
	pass

func _on_assassin_touch_floor():
	var dust = dust_resource.instance()
	dust.position = $Assassin.position
	dust.get_node("dust").animation = "landing"
	add_child(dust)

func _on_Assassin_ded():
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), -5)
	Music.change_music(Music.you_died)
	$CanvasLayer/HUD/Retry.show()


func _on_Assassin_air_jumped():
	var dust = dust_resource.instance()
	dust.position = $Assassin.position
	dust.get_node("dust").animation = "before_jump"
	add_child(dust)


func _on_HUD_respawn():
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), 0)
	$Assassin.position = GameSwitches.assassin_spawnpoint
	GameSwitches.state = GameSwitches.REVIVE
	GameSwitches.load_data()
	
	$Assassin.dead = false
	$Assassin.reviving = true
	
	# collision layer for the assassin comes back after they are revived
	
	# "|" adds binary numbers together
	$Assassin.collision_mask = GameSwitches.terrain_layer | GameSwitches.coin_layer
	
	$CanvasLayer/HUD/Retry.hide()
	Music.change_music(Music.chip_joy_loop)


func _on_Flipper_body_entered(body):
	$CanvasLayer/HUD/ToolTip.show()
	$CanvasLayer/HUD/ToolTip/XMarksTheSpot.show()
	yield(get_tree().create_timer(7.0), "timeout")
	$CanvasLayer/HUD/ToolTip.hide()
	$CanvasLayer/HUD/ToolTip/XMarksTheSpot.hide()
	

func _on_Health_body_entered(body):
	$CanvasLayer/HUD/ToolTip.show()
	$CanvasLayer/HUD/ToolTip/RealHumanHearts.show()
	yield(get_tree().create_timer(5.0), "timeout")
	$CanvasLayer/HUD/ToolTip.hide()
	$CanvasLayer/HUD/ToolTip/RealHumanHearts.hide()


func _on_Checkpoint_body_entered(body):
	$CanvasLayer/HUD/ToolTip.show()
	$CanvasLayer/HUD/ToolTip/CheckThisOut.show()
	yield(get_tree().create_timer(5.0), "timeout")
	$CanvasLayer/HUD/ToolTip.hide()
	$CanvasLayer/HUD/ToolTip/CheckThisOut.hide()

func _on_BoundPadLanding_body_entered(body):
	GameSwitches.state = GameSwitches.NORMAL

 
func _on_To_Castle_body_entered(body):
	$"Enemies/Up Bat/PathFollow2D/Flying Enemy".flying_down = true
	$Assassin.velocity = Vector2.ZERO
	GameSwitches.state = GameSwitches.INACTIVE
	$Assassin/AnimatedSprite.play("idle")
	$CameraPanTimer.start()

func _on_CameraPanTimer_timeout():
	$"Assassin/Change Camera Zoom".interpolate_property(
		$Assassin/Camera2D, "global_position", 
		$Assassin/Camera2D.global_position, $TransitionCameraPos.position, 
		1.0, Tween.TRANS_SINE)
	$"Assassin/Change Camera Zoom".start()
	$ShowFlipperTimer.start()

func _on_ShowFlipperTimer_timeout():
	$"To Castle/Flipper".show()
	$FlipEnemyTimer.start()

func _on_FlipEnemyTimer_timeout():
	$"Enemies/Up Bat/PathFollow2D/Flying Enemy".flip()
	GameSwitches.flipped = true
	$HideFlipperTimer.start()

func _on_HideFlipperTimer_timeout():
	$"To Castle/Flipper".hide()
	var new_camera = Camera2D.new()
	new_camera.global_position = $TransitionCameraPos.position
	new_camera.current = true
	new_camera.zoom = Vector2(1.5, 1.5)
	add_child(new_camera)
	$"To Castle".monitoring = false
	GameSwitches.state = GameSwitches.NORMAL

func _on_Assassin_on_friendly_bat():
	if going_out_of_cave == false:
		initiate_liftoff()
		going_out_of_cave = true

func initiate_liftoff():
	$Assassin.velocity = Vector2.ZERO
	$Assassin/AnimatedSprite.play("idle")
	GameSwitches.state = GameSwitches.INACTIVE
	yield(get_tree().create_timer(1.0), "timeout")
	$"Enemies/Up Bat/PathFollow2D/Flying Enemy".flying_up = true
	$"Enemies/Up Bat/PathFollow2D/RemoteTransform2D".global_position.x = $Assassin.global_position.x
	$"Enemies/Up Bat/PathFollow2D/RemoteTransform2D".set_remote_node("../../../../Assassin")
	yield(get_tree().create_timer(2.0), "timeout")
	$Assassin.global_position = Vector2(200,0)
	$"CanvasLayer/SceneTransitionRect".transition_to("res://Scenes/Castle.tscn")
