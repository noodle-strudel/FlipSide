extends Node2D

var dust_resource = preload("res://Scenes/dust.tscn")

var flip_original = preload("res://Assets/Tileset/real_tileset.png")
var flip_warp = preload("res://Assets/Tileset/flip tileset.png")
var got_a_ride = false
var throw_knife = false

var dialog = Dialogic.start("king_dialog")

func _ready():
	GameSwitches.assassin_spawnpoint = Vector2(768, 384)
	GameSwitches.can_flip = false
	GameSwitches.flipped = true
	get_tree().call_group("enemy", "flip")
	$"Details Foreground".tile_set.tile_set_texture(0, flip_warp)
	Save.game_data.scene = get_tree().get_current_scene().filename
	GameSwitches.save_data()
	
	Music.change_music(null)

func _physics_process(delta):
	
	
	if got_a_ride == false:
		GameSwitches.state = GameSwitches.INACTIVE
		if $"Flying Enemy Path/PathFollow2D".unit_offset == 1:
			GameSwitches.state = GameSwitches.NORMAL
			GameSwitches.can_flip = true
			got_a_ride = true
		
	if throw_knife == true:
		$KnifePath/PathFollow2D.unit_offset += 2 * delta
		
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
	Music.change_music(null)



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
	yield(get_tree().create_timer(1.0), "timeout")
	$"Assassin/Change Camera Zoom".interpolate_property(
		$Assassin/Camera2D, "global_position", 
		$Assassin/Camera2D.global_position, Vector2(6336, $Assassin/Camera2D.global_position.y), 
		1.0, Tween.TRANS_SINE)
	$"Assassin/Change Camera Zoom".start()
	yield(get_tree().create_timer(1.0), "timeout")
	var new_camera = Camera2D.new()
	new_camera.global_position = $Assassin/Camera2D.global_position
	new_camera.current = true
	new_camera.zoom = Vector2(1.25, 1.25)
	new_camera.limit_bottom = 600
	add_child(new_camera)
	add_child(dialog)
	dialog.connect("dialogic_signal", self, "king_movements")

func king_movements(movement):
	match movement:
		"open":
			$King/Face.play("open")
		"rest":
			$King/Face.play("resting face")
		"talk":
			$King/Face.play("talk")
		"laugh":
			$King/Face.play("laugh")
		"arms_up":
			$King/Torso.play("king arms move up")
		"arms_down":
			$King/Torso.play("king arms move down")
		"feign_fight":
			Music.change_music(Music.walk_glass)
			$higherLevel.playing = false
		"assassinate":
			$Assassin.velocity.y -= 1000
			yield(get_tree().create_timer(0.5), "timeout")
			$KnifePath.show()
			throw_knife = true
			yield(get_tree().create_timer(0.25), "timeout")
			$King/Face.play("open")
		"poof":
			Music.change_music(null)
			$King/StonePoof.emitting = true
			$KnifePath.hide()
			$King/Legs.hide()
			$King/Torso.hide()
			$King/Face.hide()
			$ThroneGlow.show()
			$TriggerKing.monitoring = false
			$NoEscape.collision_mask = 0b0001
			GameSwitches.state = GameSwitches.NORMAL
		


func _on_ThroneTouch_body_entered(body):
	GameSwitches.state = GameSwitches.INACTIVE
	$CanvasLayer/SceneTransitionRect.transition_to("res://Scenes/credits.tscn")


func _on_Bottomless_Pit_body_entered(body):
	GameSwitches.health = 0
	BackgroundMusic.playing = false
	GameSwitches.state = GameSwitches.DED
