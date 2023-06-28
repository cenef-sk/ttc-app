extends Control

onready var progressbar = get_node("VBoxContainer/ProgressBar")
onready var tween = get_node("Tween")
onready var tween2 = get_node("Tween2")

onready var gameMng = get_node("/root/GameManagement")
onready var gameData = get_node("/root/GameData")
onready var utils = get_node("/root/Utils")

signal allow_flipping
signal pair_match

var num_flipped = 0
var flipped = [-1, -1]

var game_id = null

var num_matches = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("pair_match", self, "_on_Pair_Match")
	var activity = gameData.activity
# 	TODO time constrain
#	tween.interpolate_method(progressbar.get("custom_styles/fg"), "set_bg_color", Color("1a6592"), Color("fc6161"), 10, Tween.TRANS_CIRC, Tween.EASE_IN)
#	tween.start()
	if (activity.has("config") and activity.config.has("time")):	
		var time = activity.config.time
		if int(time) > 0:
			print(time)
			$VBoxContainer/TimeConstrain.setTimer(int(time))
			$VBoxContainer/TimeConstrain.show()
			$VBoxContainer/TimeConstrain.start()

	var pairs = activity.content.pairs
#	var path = "user://games/" + game._id + "/assets/" + pairs[0].item1.img
	var cards = get_tree().get_nodes_in_group("cards")
	var sCards = utils.shuffleList(cards)
	for id in sCards.size():
		var card = sCards[id]
		card.connect("card_flipped", self, "_on_Card_Flipped")
#		generate random ids 
		card.id = id/2
		if pairs.size() > (id/2):
			if id%2:
				if pairs[id/2].item2.has("crop"):
					var c = pairs[id/2].item2.crop
					var crop = Rect2(c.left, c.top, c.width, c.height)
					if (pairs[id/2].item2.img):
						var img = pairs[id/2].item2.img
						card.setTexture(img, crop)
				var text = pairs[id/2].item2.text
				if text:
					card.setText(text)
			else:
				if pairs[id/2].item1.has("crop"):
					var c = pairs[id/2].item1.crop
					var crop = Rect2(c.left, c.top, c.width, c.height)
					if (pairs[id/2].item1.img):
						var img = pairs[id/2].item1.img
						card.setTexture(img, crop)
				var text = pairs[id/2].item1.text
				if text:
					card.setText(text)

func _on_Results_Closed():
	gameData.activty_finished()
	gameData.reset_activity()
	SceneTransition.change_scene("res://navigation/map/map.tscn")

func _on_Pair_Match():
	num_matches = num_matches + 1
	if num_matches == 6:
		$VBoxContainer/TimeConstrain.stop()
		$Results.set_results(create_results())
		$Results.connect("results_closed", self, "_on_Results_Closed")
		$Results.visible = true

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
	var total = gameData.pair_flips
	res += "Našiel si všetky páry."
	res += "\n"
	res += "Celkový počet otočení kartičiek: " + String(total)
	res += "\n"
	if gameData.activity.config && gameData.activity.config.has("outPass"):
		if gameData.activity.config.outPass:
			res += "\n"
			res += "Získal si heslo: " + gameData.activity.config.outPass
			res += "\n"
	return res

func create_results_en():
	var res = ""
	var total = gameData.pair_flips
	res += "You found all the pairs."
	res += "\n"
	res += "Total number of card spins: " + String(total)
	res += "\n"
	if gameData.activity.config && gameData.activity.config.has("outPass"):
		if gameData.activity.config.outPass:
			res += "\n"
			res += "You have received a password: " + gameData.activity.config.outPass
			res += "\n"
	return res

func create_results_cs():
	var res = ""
	var total = gameData.pair_flips
	res += "Našel jsi všechny páry."
	res += "\n"
	res += "Celkový počet otočení kartiček: " + String(total)
	res += "\n"
	if gameData.activity.config && gameData.activity.config.has("outPass"):
		if gameData.activity.config.outPass:
			res += "\n"
			res += "Získal si heslo: " + gameData.activity.config.outPass
			res += "\n"
	return res

func create_results_pl():
	var res = ""
	var total = gameData.pair_flips
	res += "Znalazłeś wszystkie pary."
	res += "\n"
	res += "Całkowita liczba obrotów kartami: " + String(total)
	res += "\n"
	if gameData.activity.config && gameData.activity.config.has("outPass"):
		if gameData.activity.config.outPass:
			res += "\n"
			res += "Otrzymałeś hasło: " + gameData.activity.config.outPass
			res += "\n"
	return res
		
func _on_Card_Flipped(id):
	print(id)
	flipped[num_flipped] = id
	num_flipped += 1
	if (num_flipped >= 2):
		gameData.pair_flip()
		emit_signal("allow_flipping", false)
		$UnflipTimer.start()
			

func _on_TextureRect_gui_input(event):
	if (event is InputEventMouseButton && event.pressed):
		print("scaling")
		var rect = get_node("VBoxContainer/GridContainer/TextureRect")
		print(rect.rect_scale)
		tween2.interpolate_property(rect, "rect_scale", Vector2(1, 1), Vector2(0, 1), 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN)
		tween2.start()


func _on_Tween2_tween_all_completed():
	get_node("CenterContainer").show()
	pass # Replace with function body.


func _on_UnflipTimer_timeout():
	num_flipped = 0
	if (flipped[0] == flipped[1]):
		var explanation = null
		if gameData.activity.content.pairs.size() > flipped[0]:
			explanation = gameData.activity.content.pairs[flipped[0]].explanation
		if explanation:
			$Explanation.set_explanation(explanation)
			$Explanation.connect("explanation_closed", self, "_on_Explanation_Closed")
			$Explanation.visible = true
		else:
			emit_signal("pair_match")
			emit_signal("allow_flipping", true)
	else:
		emit_signal("allow_flipping", true)

func _on_Explanation_Closed():
	$Explanation.visible = false
	emit_signal("pair_match")	
	emit_signal("allow_flipping", true)

