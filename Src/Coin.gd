extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func flip():
	if GameSwitches.flipped == true:
		$Sprite.frame = 1
		$"Real Coin/CollisionShape2D".disabled = true
		$"Anti Coin/CollisionShape2D".disabled = false
	else:
		$Sprite.frame = 0
		$"Real Coin/CollisionShape2D".disabled = false
		$"Anti Coin/CollisionShape2D".disabled = true


func _on_Real_Coin_body_entered(body):
	GameSwitches.coins += 1
	queue_free()
