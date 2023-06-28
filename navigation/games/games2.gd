extends Control

onready var gameMng = get_node("/root/GameManagement")
onready var gameData = get_node("/root/GameData")
var gameRecord = preload("res://navigation/games/GameRecord.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	var data = gameMng.loadConfig()
	print("CONFIG")
	print(data)
	if (data):
		Config.load(data)
	else:
		Config.setLng("sk")
		gameMng.save_config(Config.save())
		
	gameMng.connect("games_downloaded", self, "_on_Games_Downloaded")
	gameMng.connect("games_offline", self, "_on_Games_Downloaded")
	gameMng.games_download()
#	print(OS.get_unique_id ())
	if !gameData.is_test_mode():
		print("OS")
		print(OS.get_cmdline_args().size())
		print(get_parameter("game_id"))
		var game_id = get_parameter("game_id")
		var admin = get_parameter("admin")
		if admin:
			gameData.set_admin_mode()
			print("ADMIN MODE")
			print(admin)
			
		if game_id:
			print("GAME ID")
			print(game_id)
			gameData.set_cur_game_id(game_id)
			gameData.set_test_mode()
			SceneTransition.change_scene("res://navigation/download/download.tscn")

func get_parameter(parameter):
	if OS.has_feature('JavaScript'):
		return JavaScript.eval(""" 
			var url_string = window.location.href;
			console.log(url_string)
			var url = new URL(url_string);
			url.searchParams.get('""" + parameter + """');
			""")
	return null

func _on_Games_Downloaded():
	var games = gameMng.games_load()
	print(games.size())
	for item in games:	
		var game = gameRecord.instance()
		game.id = item.game
		print("Toto" + game.id)
		var status = gameMng.game_status(game.id, item)
		print(status)
		game.set_status(status)
		game.set_name(item.name)
		game.set_org_name(item.owner.name)
		game.set_difficutly(item.difficulty)
		$Bg/ScrollContainer/VBoxContainer.add_child(game)
	$Bg/ScrollContainer/VBoxContainer.add_child(Container.new())


func _on_Info_gui_input(event):
	if (event is InputEventMouseButton && event.pressed):
		SceneTransition.change_scene("res://navigation/info/info.tscn")


func _on_Settings_gui_input(event):
	if (event is InputEventMouseButton && event.pressed):
		SceneTransition.change_scene("res://navigation/games/settings.tscn")


func _on_Button_pressed():
	var code = $Bg/PaperLike/HBoxContainer/GameCode.text
	if code:
		print(code)
		gameData.set_cur_game_code(code)
		SceneTransition.change_scene("res://navigation/download/download.tscn")
