extends Node

var dust_resource = preload("res://Scenes/dust.tscn")

var flip_original = preload("res://Assets/Tileset/real_tileset.png")
var flip_warp = preload("res://Assets/Tileset/flip tileset.png")

func _ready():
	GameSwitches.assassin_spawnpoint = Vector2(200, 8)
	$Assassin.position = GameSwitches.assassin_spawnpoint
	
	Music.change_music(Music.chip_joy_loop)

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
			$"Terrain".tile_set.tile_set_texture(0, flip_warp)
			
			GameSwitches.flipped = true
		else:
			$"Terrain".tile_set.tile_set_texture(0, flip_original)
			
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
	GameSwitches.health = 3
	$Assassin.dead = false
	$Assassin.reviving = true
	$CanvasLayer/HUD/Retry.hide()
	Music.change_music(Music.chip_joy_loop)


func _on_Flipper_body_entered(body):
	GameSwitches.can_flip = true
	$Flipper.queue_free()
	$CanvasLayer/HUD/ToolTip.show()
	$CanvasLayer/HUD/ToolTip/XMarksTheSpot.show()
	yield(get_tree().create_timer(7.0), "timeout")
	$CanvasLayer/HUD/ToolTip.hide()
	$CanvasLayer/HUD/ToolTip/XMarksTheSpot.hide()
	$"Nothing to see here".show()
	


func _on_Health_body_entered(body):
	GameSwitches.health += 1
	$Health.queue_free()
	$CanvasLayer/HUD/ToolTip.show()
	$CanvasLayer/HUD/ToolTip/RealHumanHearts.show()
	yield(get_tree().create_timer(5.0), "timeout")
	$CanvasLayer/HUD/ToolTip.hide()
	$CanvasLayer/HUD/ToolTip/RealHumanHearts.hide()


func _on_Checkpoint_body_entered():
	$CanvasLayer/HUD/ToolTip.show()
	$CanvasLayer/HUD/ToolTip/CheckThisOut.show()
	yield(get_tree().create_timer(5.0), "timeout")
	$CanvasLayer/HUD/ToolTip.hide()
	$CanvasLayer/HUD/ToolTip/CheckThisOut.hide()
