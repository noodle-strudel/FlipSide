extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Checkpoint_body_entered(body):
	GameSwitches.assassin_spawnpoint = global_position
	$AnimatedSprite.play("saving")
	$Save.playing = true
	yield($Save, "finished")
	yield($AnimatedSprite, "animation_finished")
	$AnimatedSprite.play("idle")
