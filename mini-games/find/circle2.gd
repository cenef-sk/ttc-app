extends Node2D


onready var gameData = get_node("/root/GameData")
onready var tween = get_node("Tween")
var scaleDef = Vector2(0.307, 0.307)

signal poi_found

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_Area2D_input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton && event.pressed):
		var s = get_node("Check")
		show_check()
		tween.interpolate_property(s, "scale", s.scale, Vector2(0.4, 0.4), 1, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
		tween.start()		


func _on_Tween_tween_all_completed():
	emit_signal("poi_found")

func show_check():
	$Check.visible = true
