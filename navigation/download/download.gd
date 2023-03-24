extends Control

onready var gameMng = get_node("/root/GameManagement")
onready var gameData = get_node("/root/GameData")
var counter = 0
var step = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	gameMng.connect("game_download_update", self, "_on_Game_Download_Update")	
	gameMng.connect("game_download_started", self, "_on_Game_Download_Started")	
	gameMng.connect("game_id_retrieved", self, "_on_Game_Id_Retrieved")	
	
	if (gameData.game_code):
		gameMng.game_code_download(gameData.game_code)		
	else:
		gameMng.game_download(gameData.game_id)
	
	pass # Replace with function body.

func _on_Game_Id_Retrieved(gameId):
	gameData.set_cur_game_id(gameId)
	
func _on_Game_Download_Update(assetId):
	counter = counter - 1
	$TextureRect/VBoxContainer/ProgressBar.value = $TextureRect/VBoxContainer/ProgressBar.value + step
	if (counter <= 0 ):
		if gameData.is_test_mode():
			gameData.set_cur_game(gameMng.game_load(gameData.game_id))
			SceneTransition.change_scene("res://navigation/map/map.tscn")
#			TODO add here admin, published to map
		elif (gameData.game_code):
			gameData.set_cur_game(gameMng.game_load(gameData.game_id))
			SceneTransition.change_scene("res://navigation/map/map.tscn")			
		else:
			SceneTransition.change_scene("res://navigation/games/games2.tscn")
			gameData.reset()
			
func _on_Game_Download_Started(assets):
	print("assets")
	print(assets)
	if (assets && assets.size()):
		counter = assets.size()
		step = (100 - 5) / counter
	else: 
		SceneTransition.change_scene("res://navigation/games/games2.tscn")
		gameData.reset()
		
