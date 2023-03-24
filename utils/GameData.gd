extends Node

onready var gameMng = get_node("/root/GameManagement")

var game_code = null
var game_id = null
var game = null
var test_mode = false
var activity = null
var activity_index = null
var finished_activities = []
var unlocked_activities = []

var intro_shown = false
var end_shown = false

#QUIZ also reused fro OPEN QUESTION
var question_index = 0
var quiz_answers = []

#MEMORY
var pair_flips = 0

#TIMELINE
#uses pair_flips from MEMORY

#FIND ON IMAGE
var poi_index = 0
var found_pois = []

func analytics(data):
	if (game.has("downloadId")):
		var body = {"data": data}
		gameMng.game_analytics(game_id, game._id, body, game.downloadId)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func introShown():
	intro_shown = true

func endShown():
	end_shown = true

func set_cur_game_id(id):
	game_id = id
	
func set_cur_game_code(code):
	game_code = code
	
func set_cur_game(game):
	self.game = game
	finished_activities = gameMng.load_finished_activities(game_id)
	unlocked_activities = gameMng.load_unlocked_activities(game_id)

func set_cur_activity(activity, activity_index):
	self.activity = activity
	self.activity_index = activity_index
	
func reset():
	game_id = null
	game = null
	game_code = null
	intro_shown = false
	end_shown = false
	finished_activities = []
	unlocked_activities = []
	reset_activity()

func reset_activity():
	activity = null
	question_index = 0
	quiz_answers = []
	activity_index = null
	pair_flips = 0
	poi_index = 0
	found_pois = []
	
func pair_flip():
	pair_flips +=1

func activty_unlock():
	if !unlocked_activities.count(activity_index):
		unlocked_activities.push_back(activity_index)
		gameMng.save_unlocked_activities(game_id, unlocked_activities)

func activty_finished():
	if !finished_activities.count(activity_index):
		finished_activities.push_back(activity_index)
		gameMng.save_finished_activities(game_id, finished_activities)
	
func set_test_mode():
	test_mode = true
	
func is_test_mode():
	return test_mode
	
#QUESTION FUNCTIONS
func next_question():
	if (activity && activity.content && activity.content.questions && activity.content.questions.size()):
		var questions = activity.content.questions
		if (question_index < questions.size()):
			var res = questions[question_index]
			question_index += 1 
			return res
		else:
			return null	
	else:
		return null	
		
func has_next_question():
	if (activity && activity.content && activity.content.questions && activity.content.questions.size()):
		var questions = activity.content.questions
		if (question_index < questions.size()):
			return true
	return false

func add_answer(is_correct):
	quiz_answers.push_back(is_correct)

#FIND ON IMAGE
func reset_pois():
	poi_index = 0

func next_poi():
	if (activity && activity.content && activity.content.pois && activity.content.pois.size()):
		var pois = activity.content.pois
		if (poi_index < pois.size()):
			var res = pois[poi_index]
			poi_index += 1 
			return res
		else:
			return null	
	else:
		return null	
		
func has_next_poi():
	if (activity && activity.content && activity.content.pois && activity.content.pois.size()):
		var pois = activity.content.pois
		if (poi_index < pois.size()):
			return true
	return false

func add_poi(is_correct):
	found_pois.push_back(is_correct)
