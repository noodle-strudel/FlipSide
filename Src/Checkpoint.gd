extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _on_Checkpoint_body_entered(body):
	GameSwitches.assassin_spawnpoint = global_position
	GameSwitches.save_data()
	$AnimatedSprite.play("saving")
	$Save.playing = true
	yield($Save, "finished")
	yield($AnimatedSprite, "animation_finished")
	$AnimatedSprite.play("idle")
