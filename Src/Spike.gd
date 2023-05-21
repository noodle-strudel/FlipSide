extends StaticBody2D

var is_bounce_pad: bool


# Called when the node enters the scene tree for the first time.
func _ready():
	is_bounce_pad = true if $AnimatedSprite.animation == "bounce_pad" else false


func flip():
	if $AnimatedSprite.animation == "spike":
		$AnimatedSprite.animation = "bounce_pad"
		is_bounce_pad = true
	else:
		$AnimatedSprite.animation = "spike"
		is_bounce_pad = false
		
