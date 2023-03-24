extends Control

export var id = ""
export var gameName = ""
export var organisationName = "" 
export var rating = 5
export var difficulty = 0
export var status = ""

onready var config = get_node("/root/Config")
onready var gameData = get_node("/root/GameData")
onready var gameMng = get_node("/root/GameManagement")

var diff = preload("res://navigation/games/difficulty.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func set_name (name):
	gameName = name
	$VBoxContainer/Label.text = gameName

func set_org_name (name):
	organisationName = name
	$VBoxContainer/HBoxContainer/Label2.text = organisationName
		
func set_difficutly(level):
	difficulty = level
	if level >= 0:
		for n in (level + 1):
			var d = diff.instance()
			$VBoxContainer/HBoxContainer/Difficulty.add_child(d)

func set_status(stat):
	status = stat
	if (status == "play"):
		$Button.text = playText()
	if (status == "download"):
		$Button.text = downText()
	if (status == "update"):
		$Button.text = updateText()

func playText():
	match Config.lng:
		"sk":
			return "Hraj hru"
		"en":
			return "Play"
		"cs":
			return "Hraj hru"
		"pl":
			return "Grać w grę"

func downText():
	match Config.lng:
		"sk":
			return "Stiahni hru"
		"en":
			return "Download"
		"cs":
			return "Stáhni hru"
		"pl":
			return "Pobierz grę"
				
func updateText():
	match Config.lng:
		"sk":
			return "Updatni hru"
		"en":
			return "Update"
		"cs":
			return "Updatní hru"
		"pl":
			return "Zaktualizuj grę"

func _on_Button_gui_input(event):
	if (event is InputEventMouseButton && event.pressed && event.button_index == BUTTON_LEFT):
		gameData.set_cur_game_id(id)
		if (status == "play"):
			gameData.set_cur_game(gameMng.game_load(id))
			SceneTransition.change_scene("res://navigation/map/map.tscn")
		if (status == "download"):
			SceneTransition.change_scene("res://navigation/download/download.tscn")
		if (status == "update"):
			SceneTransition.change_scene("res://navigation/download/download.tscn")

