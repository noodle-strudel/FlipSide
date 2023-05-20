extends Node

var chip_joy_loop = preload("res://Music/Chipjoy_Loop.mp3")
var chip_joy = preload("res://Music/Chipjoy.mp3")
var break_leg = preload("res://Music/Break A Leg.mp3")
var here_go = preload("res://Music/Here We Go.mp3")
var you_died = preload("res://Music/Oh No, You Died.mp3")
var credit_samba = preload("res://Music/Credit Samba.mp3")
var disco_mode = preload("res://Music/Disco Mode!.mp3")
var higher_level = preload("res://Music/Higher Level.mp3")
var switcharoo = preload("res://Music/Switcharoo.mp3")
var walk_glass = preload("res://Music/Walking On Broken Glass.mp3")

onready var music_animation_player = get_node("/root/BackgroundMusic/AnimationPlayer")

func change_music(music):
	BackgroundMusic.volume_db = -10
	BackgroundMusic.stream = music
	BackgroundMusic.playing = true

func fade_music():
	music_animation_player.play("fade")
