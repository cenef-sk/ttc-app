extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var config = get_node("/root/Config")


# Called when the node enters the scene tree for the first time.
func _ready():
	if (config.c1):
		get_node("ParallaxBackground/ParallaxLayer/no1/Sprite").hide()
		get_node("ParallaxBackground/ParallaxLayer/no1/Sprite2").show()
	if (config.c2):
		get_node("ParallaxBackground/ParallaxLayer/no2/Sprite").hide()
		get_node("ParallaxBackground/ParallaxLayer/no2/Sprite3").show()
	if (config.c3):
		get_node("ParallaxBackground/ParallaxLayer/no3/Sprite").hide()
		get_node("ParallaxBackground/ParallaxLayer/no3/Sprite4").show()
	if (config.c4):
		get_node("ParallaxBackground/ParallaxLayer/no4/Sprite").hide()
		get_node("ParallaxBackground/ParallaxLayer/no4/Sprite5").show()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("ui_right"):
		$Camera2D.position.x += 1000 * delta
		$Camera2D.position.x = clamp($Camera2D.position.x, -1600, 1600)
	if Input.is_action_pressed("ui_left"):
		$Camera2D.position.x -= 1000 * delta
		$Camera2D.position.x = clamp($Camera2D.position.x, -1600, 1600)

func _unhandled_input(event):
#	if event is InputEventScreenTouch:
#		if event.pressed:
#			pass
	if event is InputEventScreenDrag:
		$Camera2D.position.x -= event.relative.x * 1
		$Camera2D.position.x = clamp($Camera2D.position.x, -1600, 1600)
		




func _on_Area2D_mouse_entered():
	pass # Replace with function body.


func _on_Area2D1_input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton && event.pressed):
		get_node("ParallaxBackground/ParallaxLayer/no1/Sprite").hide()
		get_node("ParallaxBackground/ParallaxLayer/no1/Sprite2").show()
		config.c1 = true
		get_tree().change_scene("res://mini-games/yesno/BYesNo.tscn")
	pass # Replace with function body.

func _on_Area2D2_input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton && event.pressed):
		get_node("ParallaxBackground/ParallaxLayer/no2/Sprite").hide()
		get_node("ParallaxBackground/ParallaxLayer/no2/Sprite3").show()
		config.c2 = true
		get_tree().change_scene("res://mini-games/quiz/BQuiz.tscn")
	pass # Replace with function body.

func _on_Area2D3_input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton && event.pressed):
		get_node("ParallaxBackground/ParallaxLayer/no3/Sprite").hide()
		get_node("ParallaxBackground/ParallaxLayer/no3/Sprite4").show()
		config.c3 = true		
		get_tree().change_scene("res://mini-games/pairs/BPairs.tscn")
	pass # Replace with function body.

func _on_Area2D4_input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton && event.pressed):
		get_node("ParallaxBackground/ParallaxLayer/no4/Sprite").hide()
		get_node("ParallaxBackground/ParallaxLayer/no4/Sprite5").show()
		config.c4 = true		
		get_tree().change_scene("res://mini-games/find/BFind.tscn")
	pass # Replace with function body.

func _on_Area2D5_input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton && event.pressed):
		get_tree().change_scene("res://mini-games/info/BInfo.tscn")
	pass # Replace with function body.
