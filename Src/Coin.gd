extends Node2D

var not_collected = true
# Called when the node enters the scene tree for the first time.
func _ready():
	GameSwitches.connect("respawn_coins", self, "respawn")
	# will eventually make it so the coins dont just disappear lol
	if GameSwitches.assassin_spawnpoint.x > global_position.x:
		queue_free()


func flip():
	if GameSwitches.flipped == true:
		$Sprite.frame = 1
		$"Real Coin/CollisionShape2D".disabled = true
		if not_collected:
			$"Anti Coin/CollisionShape2D".disabled = false
	else:
		$Sprite.frame = 0
		$"Real Coin/CollisionShape2D".disabled = false
		$"Anti Coin/CollisionShape2D".disabled = true


func _on_Real_Coin_body_entered(body):
	GameSwitches.coins += 1
	not_collected = false
	$coinGet.play()
	hide()
	$"Anti Coin/CollisionShape2D".set_deferred("disabled", true)
	$"Real Coin/CollisionShape2D".set_deferred("disabled", true)

func respawn():
	not_collected = true
	flip()
	show()
	
