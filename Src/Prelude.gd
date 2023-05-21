extends Control



# Called when the node enters the scene tree for the first time.
func _ready():
	Save.game_data.scene = filename
	var dialog = Dialogic.start("intro_dialog")
	add_child(dialog)
	dialog.connect("timeline_end", self, "end_dialog")

func end_dialog(thing):
	$SceneTransitionRect.transition_to("res://Scenes/level.tscn")
