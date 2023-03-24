extends Control

export var isMap =  false

onready var gameMng = get_node("/root/GameManagement")
onready var gameData = get_node("/root/GameData")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_pressed():
	$ButtonMenu.visible = true


func _on_Exit_pressed():
	print("EXITING")
	if (isMap):
		SceneTransition.change_scene("res://navigation/games/games2.tscn")
		gameData.reset()
	else:
		gameData.reset_activity()
		SceneTransition.change_scene("res://navigation/map/map.tscn")

func _on_ButtonMenu_gui_input(event):
	if (event is InputEventMouseButton && event.pressed):
		$ButtonMenu.visible = false
		$BlockMenu.visible = false
		$ReportMenu.visible = false


func _on_Block_pressed():
		$BlockMenu.visible = true

func _on_Report_pressed():
	$ReportMenu.visible = true

func _on_ReportSend_pressed():
	var reason = $ReportMenu/VBoxContainer/TextEdit.text
	var id = gameData.game_id
	gameMng.connect("game_reported", self, "_on_Game_Reported")
	gameMng.connect("game_report_error", self, "_on_Game_Report_Error")
	gameMng.game_report(id, reason)

func _on_Game_Reported():
	$ReportSuccess.visible = true;

func _on_Game_Report_Error():
	print("HANDLE")
	$ReportFail.visible = true;
	
func _on_BlockUser_pressed():
	Config.blockUser(gameData.game.owner)
	SceneTransition.change_scene("res://navigation/games/games2.tscn")

func _on_BlockThisGame_pressed():
	Config.blockContent(gameData.game_id)
	SceneTransition.change_scene("res://navigation/games/games2.tscn")

func _on_Ok_pressed():
	SceneTransition.change_scene("res://navigation/games/games2.tscn")
