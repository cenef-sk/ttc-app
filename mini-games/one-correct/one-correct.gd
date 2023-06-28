extends Control

	
onready var gameMng = get_node("/root/GameManagement")
onready var gameData = get_node("/root/GameData")
onready var utils = get_node("/root/Utils")
var explanation = null
var correct = null
var doNotInteract = false

# Called when the node enters the scene tree for the first time.
func _ready():
	var question = gameData.next_question()
	if (question):
		explanation = question.explanation
#		setImage(question.img)
		$VBoxContainer/Label.text = question.question
		var d = Utils.shuffleList([[$VBoxContainer/HBoxContainer/TextureRect, 1], [$VBoxContainer/HBoxContainer2/TextureRect2, 2]])
		correct = d[0][1]
		if (question.correct.has("img") and question.correct.img):
			var c = question.correct.crop
			var crop = Rect2(c.left, c.top, c.width, c.height)
			setTexture(question.correct.img, crop, d[0][0])
		if (question.correct.has("text") and question.correct.text):
			d[0][0].get_node("Label").text = question.correct.text
		if (question.wrong.has("img") and question.wrong.img):
			var c = question.wrong.crop
			var crop = Rect2(c.left, c.top, c.width, c.height)
			setTexture(question.wrong.img, crop, d[1][0])
		if (question.wrong.has("text") and question.wrong.text):
			d[1][0].get_node("Label").text = question.wrong.text
			
	else:
#		No question provided
		SceneTransition.change_scene("res://navigation/map/map.tscn")

func setTexture(asset_id, crop, obj):
	
	var atlas = AtlasTexture.new()

	var texture_path = gameMng.get_asset(gameData.game_id, asset_id)
	
	if texture_path:
		var image = Image.new()
		image.load(texture_path)
		var t = ImageTexture.new()
		t.create_from_image(image)

		atlas.atlas = t;
		atlas.margin = Rect2(0, 0, 0, 0)
		atlas.region = crop
		obj.texture = atlas
		

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


func create_results_en():
	var res = ""
	var total = gameData.quiz_answers.size()
	var correct = gameData.quiz_answers.count(true)
	res += "Answered questions: " + String(total)
	res += "\n"
	res += "Correct answers: " + String(correct)
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
	var correct = gameData.quiz_answers.count(true)
	res += "Zodpovězených otázek: " + String(total)
	res += "\n"
	res += "Správných odpovědí: " + String(correct)
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
	var correct = gameData.quiz_answers.count(true)
	res += "Odpowiedzi na pytania: " + String(total)
	res += "\n"
	res += "Poprawne odpowiedzi: " + String(correct)
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
		SceneTransition.change_scene("res://mini-games/one-correct/one-correct.tscn")
	else:
		$Results.set_results(create_results())
		$Results.connect("results_closed", self, "_on_Results_Closed")
		$Results.visible = true

#func _on_Button_pressed():
#	gameData.add_answer($VBoxContainer/TextEdit.text)
#	print($VBoxContainer/TextEdit.text)


func _on_TextureRect_gui_input(event):
	if (event is InputEventMouseButton && event.pressed && !doNotInteract):
#		is_answer_selected = true
#		emit_signal("answer_selected", is_correct)
		doNotInteract = true
		mark(correct, 1)
		$Timer.start()

func _on_TextureRect2_gui_input(event):
	if (event is InputEventMouseButton && event.pressed  && !doNotInteract):
#		is_answer_selected = true
#		emit_signal("answer_selected", is_correct)
		doNotInteract = true
		mark(correct, 2)
		$Timer.start()


func mark(correct, textRectNum):
	var component = null
	match textRectNum:
		1: component = $VBoxContainer/HBoxContainer/TextureRect
		2: component = $VBoxContainer/HBoxContainer2/TextureRect2
		
	if (correct == textRectNum):
		gameData.add_answer(true)
		component.get_node("OK").show()
	else:
		gameData.add_answer(false)
		component.get_node("Wrong").show()
	
func _on_Timer_timeout():
	if explanation:
		$Explanation.set_explanation(explanation)
		$Explanation.connect("explanation_closed", self, "_on_Explanation_Closed")
		$Explanation.visible = true
	else:
		_on_Explanation_Closed()
