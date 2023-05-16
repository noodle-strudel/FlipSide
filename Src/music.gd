extends Node

var chip_joy_loop = preload("res://Music/Chipjoy_Loop.mp3")
var chip_joy = preload("res://Music/Chipjoy.mp3")
var break_leg = preload("res://Music/Break A Leg.mp3")
var here_go = preload("res://Music/Here We Go.mp3")
var you_died = preload("res://Music/Oh No, You Died.mp3")
var credit_samba = preload("res://Music/Credit Samba.mp3")
var disco_mode = preload("res://Music/Disco Mode!.mp3")

func change_music(music):
	BackgroundMusic.stream = music
	BackgroundMusic.playing = true
