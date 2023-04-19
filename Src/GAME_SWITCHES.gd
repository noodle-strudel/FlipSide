extends Node

enum {NORMAL, HIT, DED, ATTACK, REVIVE, INACTIVE}
var state
var health: int
var coins: int
var assassin_spawnpoint: Vector2
var checkpoint_save = {}

var can_flip = false
var gonna_flip = false
var flipped = false

func save_data():
	checkpoint_save = {
		"health" : health,
	}

func load_data():
	health = checkpoint_save["health"]
