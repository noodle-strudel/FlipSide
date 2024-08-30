tool
extends Node2D
# the tool keyword makes it so code runs in the editor

signal powered_on
signal powered_off

export var Powered = false
var changing_states = false

func _ready():
	determine_position()

func _on_Area2D_area_entered(area):
	print("triggered")
	if Powered:
		emit_signal("powered_off")
		Powered = false
	else:
		emit_signal("powered_on")
		Powered = true
	
	determine_position()


func _on_Area2D_area_exited(area):
	print(area, "has exited")


# handle will face left if powered, else it will face right
func determine_position():
	if Powered:
		$Handle.rotation_degrees = -45
	else:
		$Handle.rotation_degrees = 45


func _on_Area2D_body_entered(body):
	if Powered:
		emit_signal("powered_off")
		Powered = false
	else:
		emit_signal("powered_on")
		Powered = true
	
	determine_position()


func _on_Area2D_body_exited(body):
	print("woosh exited")
