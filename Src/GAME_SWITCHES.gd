extends Node

enum {NORMAL, HIT, DED, ATTACK, REVIVE, INACTIVE, DISABLED}
var state
var health: int
var coins: int
var assassin_spawnpoint: Vector2
var checkpoint_save = {}

var can_flip = false
var gonna_flip = false
var flipped = false


var player_layer = 0b0001
var enemy_layer = 0b0011
var terrain_layer = 0b0010
var air_swoosh_layer = 0b100
var sword_layer = 0b0101
var coin_layer = 0b0111
var pass_through_layer = 0b1000
var no_collision = 0b0000


func save_data():
	Save.game_data.health = GameSwitches.health
	Save.game_data.coins = GameSwitches.coins
	Save.game_data.continue = true
	Save.game_data.spawn = GameSwitches.assassin_spawnpoint
	Save.save_data()
	
func load_data():
	GameSwitches.health = Save.game_data.health
	GameSwitches.coins = Save.game_data.coins
	GameSwitches.assassin_spawnpoint = Save.game_data.spawn
