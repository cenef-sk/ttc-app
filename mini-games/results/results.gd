extends Control

signal results_closed

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_results(results):
	$TextureRect/VBoxContainer/Label2.text = results

func _on_Results_gui_input(event):
	if (event is InputEventMouseButton && event.pressed):
		emit_signal("results_closed")
