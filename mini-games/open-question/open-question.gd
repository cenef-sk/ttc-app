extends Control


onready var gameMng = get_node("/root/GameManagement")
onready var gameData = get_node("/root/GameData")
onready var utils = get_node("/root/Utils")
var explanation = null

# Called when the node enters the scene tree for the first time.
func _ready():
	var question = gameData.next_question()
	if (question):
		explanation = question.explanation
		setImage(question.img)
		$VBoxContainer/Label.text = question.question
	else:
#		No question provided
		SceneTransition.change_scene("res://navigation/map/map.tscn")
	
func setImage(asset_id):
	if asset_id:
		var texture_path = gameMng.get_asset(gameData.game_id, asset_id)
		
		if texture_path:
			var image = Image.new()
			image.load(texture_path)
			var t = ImageTexture.new()
			t.create_from_image(image)	
			$VBoxContainer/TextureRect.texture = t

func create_results():
	match Config.lng:
		"sk":
			return create_results_sk()
		"en":
			return create_results_en()
		"cs":
			return create_results_cs()
		"pl":
			return create_results_pl()

func create_results_sk():
	var res = ""
	var total = gameData.quiz_answers.size()
	res += "Ďakujeme za odpovede."
	res += "\n"
	if gameData.activity.config && gameData.activity.config.has("outPass"):
		if gameData.activity.config.outPass:
			res += "\n"
			res += "Získal si heslo: " + gameData.activity.config.outPass
			res += "\n"
	return res

func create_results_en():
	var res = ""
	var total = gameData.quiz_answers.size()
	res += "Thanks for the answers."
	res += "\n"
	if gameData.activity.config && gameData.activity.config.has("outPass"):
		if gameData.activity.config.outPass:
			res += "\n"
			res += "You have received a password: " + gameData.activity.config.outPass
			res += "\n"
	return res

func create_results_cs():
	var res = ""
	var total = gameData.quiz_answers.size()
	res += "Děkujeme za odpovědi."
	res += "\n"
	if gameData.activity.config && gameData.activity.config.has("outPass"):
		if gameData.activity.config.outPass:
			res += "\n"
			res += "Získal si heslo: " + gameData.activity.config.outPass
			res += "\n"
	return res

func create_results_pl():
	var res = ""
	var total = gameData.quiz_answers.size()
	res += "Dzięki za odpowiedzi."
	res += "\n"
	if gameData.activity.config && gameData.activity.config.has("outPass"):
		if gameData.activity.config.outPass:
			res += "\n"
			res += "Otrzymałeś hasło: " + gameData.activity.config.outPass
			res += "\n"
	return res

func _on_Results_Closed():
	gameData.activty_finished()
	gameData.reset_activity()
	SceneTransition.change_scene("res://navigation/map/map.tscn")
		

func _on_Explanation_Closed():
	if gameData.has_next_question():
		SceneTransition.change_scene("res://mini-games/open-question/open-question.tscn")
	else:
		gameData.analytics({
			"activityIndex": gameData.activity_index,
			"data": gameData.quiz_answers
			})
		$Results.set_results(create_results())
		$Results.connect("results_closed", self, "_on_Results_Closed")
		$Results.visible = true

func _on_Button_pressed():
	gameData.add_answer($VBoxContainer/TextEdit.text)
	print($VBoxContainer/TextEdit.text)
	if explanation:
		$Explanation.set_explanation(explanation)
		$Explanation.connect("explanation_closed", self, "_on_Explanation_Closed")
		$Explanation.visible = true
	else:
		_on_Explanation_Closed()
