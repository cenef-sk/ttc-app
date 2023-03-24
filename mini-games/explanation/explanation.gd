extends Control

signal explanation_closed

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_explanation(explanation):
	$TextureRect/VBoxContainer/Label2.text = explanation

func _on_Explanation_gui_input(event):
	if (event is InputEventMouseButton && event.pressed):
		emit_signal("explanation_closed")
