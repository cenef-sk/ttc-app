extends Node2D

export var label = "0"
export var pointer = 0 

var activity_index = null
onready var gameData = get_node("/root/GameData")
onready var tween = get_node("Tween")
var scaleDef = Vector2(0.307, 0.307)



var locked = false

signal activity_locked
var in_pass = null
var in_pass_desc = null

var pointers = ['black.png', 'blue.png', 'azure.png', 'yellow.png', 'red.png', 'white.png'] 

# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.text = label
	$Sprite.texture = load("res://navigation/map/circles/" + pointers[pointer])

func set_activity_id(id):
	activity_index = id


func _on_Area2D_input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton && event.pressed):
		var s = get_node("Sprite")
		tween.interpolate_property(s, "scale", scaleDef, Vector2(0.2, 0.2), 0.1, Tween.TRANS_BOUNCE, Tween.EASE_OUT)
		tween.start()		


func _on_Tween_tween_all_completed():
	var s = get_node("Sprite")
	s.scale = scaleDef
	var activity = gameData.game.activities[activity_index]
	gameData.set_cur_activity(activity, activity_index)

	if !locked:
		if activity.type == "memory":
			SceneTransition.change_scene("res://mini-games/pairs/Pairs2.tscn")
		if activity.type == "timeline":
			SceneTransition.change_scene("res://mini-games/timeline/Timeline.tscn")
		if activity.type == "quiz":
			SceneTransition.change_scene("res://mini-games/quiz/quiz.tscn")
		if activity.type == "find-detail":
			gameData.reset_pois()
			SceneTransition.change_scene("res://mini-games/find/find.tscn")
		if activity.type == "open-question":
			SceneTransition.change_scene("res://mini-games/open-question/open-question.tscn")
		if activity.type == "one-correct":
			SceneTransition.change_scene("res://mini-games/one-correct/one-correct.tscn")
	else:
		emit_signal("activity_locked", in_pass, in_pass_desc, activity_index)

func show_check():
	$Check.visible = true
	
func show_lock(in_pass, in_pass_desc):
	$Lock.visible = true
	self.in_pass = in_pass
	self.in_pass_desc = in_pass_desc
	locked = true
	

