extends Control


func _ready():
	pass # Replace with function body.
	
func _process(delta):
	$RichTextLabel.bbcode_text = "Heath: " + str(GameSwitches.health)


func _on_Button_pressed():
	get_tree().reload_current_scene()


func _on_Menu_pressed():
	get_tree().change_scene("res://Scenes/menu.tscn")
