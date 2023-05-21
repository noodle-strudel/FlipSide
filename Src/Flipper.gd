extends Area2D

func _ready():
	if get_tree().get_current_scene().name == "Level":
		if GameSwitches.assassin_spawnpoint.x > global_position.x:
			GameSwitches.can_flip = true
			hide()
			$ominousNoise.playing = false
			collision_layer = 0
			collision_mask = 0

func _on_Flipper_body_entered(body):
	if get_parent().name != "To Castle":
		GameSwitches.can_flip = true
		$flipFlop.play()
		$ominousNoise.playing = false
		hide()
		collision_layer = 0
		collision_mask = 0

func _on_Level_revert_flipper():
	$ominousNoise.playing = true
	show()
	set_collision_layer_bit(5, true)
	set_collision_mask_bit(0, true)
