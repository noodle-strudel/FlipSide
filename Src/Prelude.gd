extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	Save.game_data.scene = filename
	var dialog = Dialogic.start("intro_dialog")
	add_child(dialog)
	dialog.connect("timeline_end", self, "end_dialog")

func end_dialog(thing):
	$SceneTransitionRect.transition_to("res://Scenes/level.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
