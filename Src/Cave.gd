extends level

var in_bat_cutscene = false
var going_out_of_cave = false

export var rave_squence: int
# Called when the node enters the scene tree for the first time.
func _ready():
	if GameSwitches.assassin_spawnpoint != $Checkpoint3.global_position:
		GameSwitches.assassin_spawnpoint = Vector2(3072, 4620)
	else:
		GameSwitches.assassin_spawnpoint = Save.game_data.spawn
	GameSwitches.can_flip = true
	$Assassin.global_position = GameSwitches.assassin_spawnpoint
	
	$Assassin/Camera2D.limit_bottom = 100000
	$Assassin/Camera2D.zoom = Vector2(1.5, 1.5)

func _on_To_Castle_body_entered(body):
	in_bat_cutscene = true
	if GameSwitches.flipped:
		do_a_flip(true)
	GameSwitches.can_flip = false
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
	if in_bat_cutscene == true and going_out_of_cave == false:
		initiate_liftoff()
		going_out_of_cave = true

func initiate_liftoff():
	$Assassin.velocity = Vector2.ZERO
	$Assassin/AnimatedSprite.play("idle")
	GameSwitches.state = GameSwitches.INACTIVE
	$HopOnBatTimer.start()

func _on_HopOnBatTimer_timeout():
	$"Enemies/Up Bat/PathFollow2D/Flying Enemy".flying_up = true
	$"Enemies/Up Bat/PathFollow2D/RemoteTransform2D".global_position.x = $Assassin.global_position.x
	$"Enemies/Up Bat/PathFollow2D/RemoteTransform2D".set_remote_node("../../../../Assassin")
	$TransitionToCastleTimer.start()

func _on_TransitionToCastleTimer_timeout():
	$Assassin.global_position = Vector2(200,0)
	$"CanvasLayer/SceneTransitionRect".transition_to("res://Scenes/Castle.tscn")

func _on_HUD_to_main_menu():
	$"CanvasLayer/SceneTransitionRect".transition_to("res://Scenes/menu.tscn")

func _on_Assassin_air_jumped():
	create_air_dust()

func _on_Assassin_ded():
	die()

func _on_Assassin_touch_floor():
	create_land_dust()

func _on_HUD_respawn():
	respawn()
