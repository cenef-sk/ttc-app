extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	
	var res = str(receivedCodesText(), "\n\n")
	var codes = ["a", "b", "c"]
	var acts = GameData.game.activities
	for c in acts.size():
		var code = "?"
		if (GameData.finished_activities.count(c)):
			if (acts[c].has("config") && acts[c].config.has("outPass")):
				code = acts[c].config.outPass
			else: 
				code = "-"
		res = str(res, taskNrText(), " ", c + 1, ": ", code, "\n")
	$LockView/Label.text = res 

func receivedCodesText():
	match Config.lng:
		"sk":
			return "Získané kódy:"
		"en":
			return "Otrzymane kody:"
		"cs":
			return "Získané kódy:"
		"pl":
			return "Otrzymane kody:"

func taskNrText():
	match Config.lng:
		"sk":
			return "úloha č."
		"en":
			return "task no."
		"cs":
			return "úkol č."
		"pl":
			return "zadanie nr."
			
func _on_Button_pressed():
		$LockView.visible = true

func _on_TextureRect_gui_input(event):
	if (event is InputEventMouseButton && event.pressed):
		$LockView.visible = false
