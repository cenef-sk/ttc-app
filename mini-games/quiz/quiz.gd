extends Control

signal answer_ready

onready var gameMng = get_node("/root/GameManagement")
onready var gameData = get_node("/root/GameData")
onready var utils = get_node("/root/Utils")
var explanation = null

# Called when the node enters the scene tree for the first time.
func _ready():
	var question = gameData.next_question()
	if (question):
		var a1 = $VBoxContainer/Answer
		var a2 = $VBoxContainer/Answer2
		var a3 = $VBoxContainer/Answer3
		var a4 = $VBoxContainer/Answer4
		a1.connect("answer_selected", self, "_on_Answer_Selected")
		a2.connect("answer_selected", self, "_on_Answer_Selected")
		a3.connect("answer_selected", self, "_on_Answer_Selected")
		a4.connect("answer_selected", self, "_on_Answer_Selected")
		explanation = question.explanation
		setImage(question.img)
		$VBoxContainer/Label.text = question.question
		var answs = question.answers
		var answers = utils.shuffleList([a1, a2, a3, a4])
		answers[0].setAnswer(answs[0], true)
		answers[1].setAnswer(answs[1], false)
		answers[2].setAnswer(answs[2], false)
		answers[3].setAnswer(answs[3], false)
	else:
#		No question provided
		SceneTransition.change_scene("res://navigation/map/map.tscn")
	
func _on_Answer_Selected(is_correct):
#	TODO save to game play object
	gameData.add_answer(is_correct)
	emit_signal("answer_ready")
	if explanation:
		$Explanation.set_explanation(explanation)
		$TimerExplanation.start()
		$Explanation.connect("explanation_closed", self, "_on_Explanation_Closed")
	else:
		$TimerNextQuestion.start()
	
func _on_Explanation_Closed():
	_on_TimerNextQuestion_timeout()
#	SceneTransition.change_scene("res://mini-games/quiz/quiz.tscn")

func _on_Results_Closed():
	gameData.activty_finished()
	gameData.reset_activity()
	SceneTransition.change_scene("res://navigation/map/map.tscn")
		

func _on_TimerNextQuestion_timeout():
#	TODO check if more questions
	if gameData.has_next_question():
		SceneTransition.change_scene("res://mini-games/quiz/quiz.tscn")
	else:
		$Results.set_results(create_results())
		$Results.connect("results_closed", self, "_on_Results_Closed")
		$Results.visible = true

func create_results():
	var res = ""
	var total = gameData.quiz_answers.size()
	var correct = gameData.quiz_answers.count(true)
	res += "Zodpovedaných otázok: " + String(total)
	res += "\n"
	res += "Správnych odpovedí: " + String(correct)
	res += "\n"
	if gameData.activity.config && gameData.activity.config.has("outPass"):
		if gameData.activity.config.outPass:
			res += "\n"
			res += "Získal si heslo: " + gameData.activity.config.outPass
			res += "\n"
	return res

func setImage(asset_id):
	if asset_id:
		var texture_path = gameMng.get_asset(gameData.game_id, asset_id)
		
		if texture_path:
			var image = Image.new()
			image.load(texture_path)
			var t = ImageTexture.new()
			t.create_from_image(image)	
			$VBoxContainer/TextureRect.texture = t

func _on_TimerExplanation_timeout():
	$Explanation.visible = true
