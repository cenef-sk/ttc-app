extends Control

signal results_closed

var in_pass = null
var activity_index = null

onready var gameData = get_node("/root/GameData")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_results(results):
	$TextureRect/VBoxContainer/Label2.text = results

func set_data(in_pass, in_pass_desc, activity_index):
	self.in_pass = in_pass
	$TextureRect/VBoxContainer/Label2.text = in_pass_desc
	self.activity_index	= activity_index


func _on_Button_pressed():
	var entered_pass = $TextureRect/VBoxContainer/LineEdit.text
	if entered_pass == in_pass:
		gameData.activty_unlock()
		var activity = gameData.game.activities[activity_index]
		if activity.type == "memory":
			SceneTransition.change_scene("res://mini-games/pairs/Pairs2.tscn")
		if activity.type == "timeline":
			SceneTransition.change_scene("res://mini-games/timeline/Timeline.tscn")
		if activity.type == "quiz":
			SceneTransition.change_scene("res://mini-games/quiz/quiz.tscn")
		if activity.type == "find-detail":
			SceneTransition.change_scene("res://mini-games/find/find.tscn")
		if activity.type == "open-question":
			SceneTransition.change_scene("res://mini-games/open-question/open-question.tscn")
		if activity.type == "one-correct":
			SceneTransition.change_scene("res://mini-games/one-correct/one-correct.tscn")
	else:
		$TextureRect/VBoxContainer/Error.show()
		$Timer.start()


func _on_Timer_timeout():
		hide()
		$TextureRect/VBoxContainer/Error.hide()
		$TextureRect/VBoxContainer/LineEdit.text = ""
