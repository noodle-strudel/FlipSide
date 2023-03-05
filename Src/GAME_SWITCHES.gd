extends Node

enum {NORMAL, HIT, DED, ATTACK, REVIVE, INACTIVE}
var state
var health: int
var coins: int
var assassin_spawnpoint: Vector2

var can_flip = false
var gonna_flip = false
var flipped = false
var falling_into_cave = false


func _ready():
	pass
