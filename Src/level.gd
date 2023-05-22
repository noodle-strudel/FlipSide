extends level

signal revert_flipper

var first_heart = true
var first_checkpoint = true
var first_ground_attack = true
var first_air_attack = true

# loads assassin spawnpoint if continuing or makes new spawnpoint if loading new game
func _ready():
	$Assassin.position = GameSwitches.assassin_spawnpoint
	if GameSwitches.assassin_spawnpoint.y < 2176:
		Music.change_music(Music.chip_joy_loop)
	else:
		$Assassin/Camera2D.limit_bottom = 10000
		Music.change_music(Music.switcharoo)
	if GameSwitches.assassin_spawnpoint == Vector2(200, 0):
		$CanvasLayer/HUD/ToolTip.show()
		$CanvasLayer/HUD/ToolTip/StartFromBasics.show()
		yield(get_tree().create_timer(5.0), "timeout")
		$CanvasLayer/HUD/ToolTip.hide()
		$CanvasLayer/HUD/ToolTip/StartFromBasics.hide()
	
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), 0)

func _on_Assassin_jumped():
	pass

func _on_assassin_touch_floor():
	create_land_dust()

func _on_Assassin_ded():
	die()

func _on_Assassin_air_jumped():
	create_air_dust()

func _on_HUD_respawn():
	respawn()
	# if the assassin's spawn point is to the left of the flipper,
	if GameSwitches.assassin_spawnpoint.x < $Flipper.global_position.x:
		# you can't flip and the flipper reappears
		GameSwitches.can_flip = false
		emit_signal("revert_flipper")


func _on_Flipper_body_entered(body):
	$CanvasLayer/HUD/ToolTip.show()
	$CanvasLayer/HUD/ToolTip/XMarksTheSpot.show()
	yield(get_tree().create_timer(7.0), "timeout")
	$CanvasLayer/HUD/ToolTip.hide()
	$CanvasLayer/HUD/ToolTip/XMarksTheSpot.hide()
	

func _on_Health_body_entered(body):
	if (first_heart == true):
		$CanvasLayer/HUD/ToolTip.show()
		$CanvasLayer/HUD/ToolTip/RealHumanHearts.show()
		yield(get_tree().create_timer(4.0), "timeout")
		$CanvasLayer/HUD/ToolTip.hide()
		$CanvasLayer/HUD/ToolTip/RealHumanHearts.hide()
		first_heart = false


func _on_Checkpoint_body_entered(body):
	if (first_checkpoint == true):
		$CanvasLayer/HUD/ToolTip.show()
		$CanvasLayer/HUD/ToolTip/CheckThisOut.show()
		yield(get_tree().create_timer(5.0), "timeout")
		$CanvasLayer/HUD/ToolTip.hide()
		$CanvasLayer/HUD/ToolTip/CheckThisOut.hide()
		first_checkpoint = false

func _on_BoundPadLanding_body_entered(body):
	GameSwitches.state = GameSwitches.NORMAL

func _on_TeachGroundAttack_body_entered(body):
	if first_ground_attack:
		$CanvasLayer/HUD/ToolTip.show()
		$CanvasLayer/HUD/ToolTip/SwordsOut.show()
		yield(get_tree().create_timer(7.0), "timeout")
		$CanvasLayer/HUD/ToolTip.hide()
		$CanvasLayer/HUD/ToolTip/SwordsOut.hide()
		first_ground_attack = false

func _on_TeachAirAttacks_body_entered(body):
	if first_air_attack:
		$CanvasLayer/HUD/ToolTip.show()
		$CanvasLayer/HUD/ToolTip/ThrowingKnives.show()
		yield(get_tree().create_timer(7.0), "timeout")
		$CanvasLayer/HUD/ToolTip.hide()
		$CanvasLayer/HUD/ToolTip/ThrowingKnives.hide()
		first_air_attack = false

func _on_HUD_to_main_menu():
	$CanvasLayer/SceneTransitionRect.transition_to("res://Scenes/menu.tscn")


func _on_Cave_Entrance_body_entered(body):
	GameSwitches.assassin_spawnpoint = Vector2(2696, 3880)
	GameSwitches.state = GameSwitches.INACTIVE
	$CanvasLayer/SceneTransitionRect.transition_to("res://Scenes/Cave.tscn")
