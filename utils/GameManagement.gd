extends Node

onready var config = get_node("/root/Config")
onready var gameData = get_node("/root/GameData")
const GAMES_PATH = "user://games"
const ASSETS_DIR = "assets"
const GAME_FILE_NAME = "game.var"
const CONFIG_FILE_NAME = "config.var"
const GAMES_FILE_NAME = "games.var"
const GAME_PROGRESS_FILE_NAME = "game_progress.var"
const GAME_PROGRESS_FILE_NAME2 = "game_progress2.var"

signal games_downloaded
signal game_download_update
signal game_download_started
signal games_offline

signal game_reported
signal game_report_error

signal game_analytics_sent
signal game_analytics_error
signal game_id_retrieved

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

#func load_game(game_id):
#	http_request_game(game_id)
#
#func delete_game(gameId):
#	pass
#
#func download_game(gameId):
#	pass
#
#func update_game(gameId):
#	pass
#
#func getLocal_games():
#	pass
#
#func getRemote_games():
#	pass
#
#func download_asset():
#	pass
#
#func get_games_statuses():
#	pass
#
#func upload_game_stats():
#	pass
	
# START API DECLARATION
func games_download():
	http_games_download()

func game_download(id):
	http_game_download(id)
	
func game_code_download(id):
	http_game_code_download(id)

func game_report(id, reason):
	http_game_report(id, reason)

func game_analytics(gameId, pubGameId, data, downloadId):
	if (!config.denyAnalytics):
		http_game_analytics(gameId, pubGameId, data, downloadId)

func game_load(id):
	return loadGame(id)

func games_load():
	return loadGames()
	
func game_status(id, downGame):
	var savedGame = game_load(id)
	if !savedGame:
		return "download"
	print("Compare")
	print(savedGame.updatedAt)
	print(downGame.updatedAt)
	if savedGame.updatedAt != downGame.updatedAt:
		print("TO")
		print(savedGame.updatedAt)
		print(downGame.updatedAt)
		return "update"
	return "play"
	
func save_finished_activities(game_id, finished_activities):
	save_game_progress(game_id, finished_activities)
	
func load_finished_activities(game_id):
	return load_game_progress(game_id)

func save_unlocked_activities(game_id, unlocked_activities):
	save_game_progress2(game_id, unlocked_activities)
	
func load_unlocked_activities(game_id):
	return load_game_progress2(game_id)
		
# END API DECLARATION
func save_game_progress(game_id, data):
	var dir = open_game_dir(game_id)
	var game_dir = dir.get_current_dir()

	var file = File.new()
	file.open(game_dir + "/" + GAME_PROGRESS_FILE_NAME, File.WRITE)
	file.store_var(data)
	file.close()

func load_game_progress (game_id):
	var dir = open_game_dir(game_id)
	var game_dir = dir.get_current_dir()
	var file = File.new()
	var path = game_dir + "/" + GAME_PROGRESS_FILE_NAME
	if file.file_exists(path):
		file.open(path, File.READ)
		var game_data = file.get_var()
		file.close()
		return game_data
	else:
		return []

func save_game_progress2(game_id, data):
	var dir = open_game_dir(game_id)
	var game_dir = dir.get_current_dir()

	var file = File.new()
	file.open(game_dir + "/" + GAME_PROGRESS_FILE_NAME2, File.WRITE)
	file.store_var(data)
	file.close()

func load_game_progress2 (game_id):
	var dir = open_game_dir(game_id)
	var game_dir = dir.get_current_dir()
	var file = File.new()
	var path = game_dir + "/" + GAME_PROGRESS_FILE_NAME2
	if file.file_exists(path):
		file.open(path, File.READ)
		var game_data = file.get_var()
		file.close()
		return game_data
	else:
		return []
		
func open_games_dir():
	var dir = Directory.new()
	dir.open("user://")
	if dir.open(GAMES_PATH) != OK:
		dir.make_dir(GAMES_PATH)
		dir.open(GAMES_PATH)
	return dir	
	
func open_game_dir(game_id):
	var dir = open_games_dir()
	var gameDir = GAMES_PATH + "/" + game_id
	if dir.open(gameDir) != OK:
		dir.make_dir(game_id)
		dir.open(gameDir)
	return dir	
	
func open_assets_dir(game_id):
	var dir = open_game_dir(game_id)
	var game_dir = dir.get_current_dir()

	var assets_dir = game_dir + "/" + ASSETS_DIR
	if dir.open(assets_dir) != OK:
		dir.make_dir(ASSETS_DIR)
		dir.open(assets_dir)	
	return dir
	
func save_game(data):
	print(data)
	save_game_progress(data.game, [])
	save_game_progress2(data.game, [])
	var dir = open_game_dir(data.game)
	var game_dir = dir.get_current_dir()

	var file = File.new()
	file.open(game_dir + "/" + GAME_FILE_NAME, File.WRITE)
	file.store_var(data)
	file.close()

func save_games(data):
	var dir = open_games_dir()
	var games_dir = dir.get_current_dir()

	var file = File.new()
	file.open(games_dir + "/" + GAMES_FILE_NAME, File.WRITE)
	file.store_var(data)
	file.close()

func save_config(data):
	var dir = open_games_dir()
	var games_dir = dir.get_current_dir()

	var file = File.new()
	file.open(games_dir + "/" + CONFIG_FILE_NAME, File.WRITE)
	file.store_var(data)
	file.close()

func loadConfig ():
	var dir = open_games_dir()
	var games_dir = dir.get_current_dir()
	var file = File.new()
	var path = games_dir + "/" + CONFIG_FILE_NAME
	if file.file_exists(path):
		file.open(path, File.READ)
		var config_data = file.get_var()
		file.close()
		return config_data
	else:
		return null
		

func loadGame (game_id):
	var dir = open_game_dir(game_id)
	var game_dir = dir.get_current_dir()
	var file = File.new()
	var path = game_dir + "/" + GAME_FILE_NAME
	if file.file_exists(path):
		file.open(path, File.READ)
		var game_data = file.get_var()
		file.close()
		return game_data
	else:
		return null

func loadGames ():
	var dir = open_games_dir()
	var games_dir = dir.get_current_dir()
	var file = File.new()
	file.open(games_dir + "/" + GAMES_FILE_NAME, File.READ)
	var games_data = file.get_var()
	file.close()
	var res = [] 
	print(Config.blockedUsers)
	for g in games_data:
		if !Config.blockedUsers.has(g.owner._id) and !Config.blockedContent.has(g.game):
			res.push_back(g)
	return res
	
#func checkBlocked(g):
#	print(g)
#	return true

func get_asset(game_id, asset_id):
	var assets_path = GAMES_PATH + "/" + game_id + "/assets"
	var files = list_files_in_directory(assets_path)
	var res = null
	for file in files:
		if file.find(asset_id + ".") != -1:
			res = file
	if res:
		return assets_path + "/" + res
	else:
		return null
	
func list_files_in_directory(path):
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()

	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			files.append(file)

	dir.list_dir_end()

	return files

# START HTTP FUNCTIONS
func http_download_asset(gameId, assetId):
	var http_request = HTTPRequest.new()
	add_child(http_request)
#	print("DOWNLOADING")
#	http_request.set_download_file("user://games/" + gameId + "/assets/" + assetId)
#	http_request.request(config.API + "/assets/" + assetId + "/media")
	http_request.connect("request_completed", self, "http_asset_download_completed", [gameId, assetId])
	var error = http_request.request(config.API + "/assets/" + assetId + "/media")
	if error != OK:
		push_error("An error occurred in the HTTP request.")
		
		
func http_asset_download_completed(result, response_code, headers, body, gameId, assetId):
#	var h = parse_json(headers)
#	print(h["Content-Type"])
	var m_type = ""
#	print(headers)
	for header in headers:
		if(header.find("Content-Type: image/") != -1):
			m_type = header.replace("Content-Type: image/", "")
		if(header.find("content-type:image/") != -1):
			m_type = header.replace("content-type:image/", "")

#	print(assetId)
#	print(m_type)
#	print(response_code) # check response code 200 otherwise error
#	var response = parse_json(body.get_string_from_utf8()).data
#	print(body.size())
	var dir = open_assets_dir(gameId)
	var assets_dir = dir.get_current_dir()
	
	var save_asset = File.new()
	save_asset.open(assets_dir + "/" + assetId + "." + m_type, File.WRITE)
	save_asset.store_buffer(body)
#	save_asset.store_var(body)
	save_asset.close()
	emit_signal("game_download_update", assetId)

func http_game_download(id):
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.connect("request_completed", self, "http_game_download_completed")
	if (!gameData.is_test_mode()) or (gameData.is_test_mode() and gameData.is_admin_mode()):
		var error = http_request.request(config.API + "/games/" + id + "/download")
		if error != OK:
			push_error("An error occurred in the HTTP request.")
	else:
		var error = http_request.request(config.API + "/games/" + id + "/test")
		if error != OK:
			push_error("An error occurred in the HTTP request.")
		

func http_game_code_download(code):
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.connect("request_completed", self, "http_game_download_completed")
	var error = http_request.request(config.API + "/games/" + code + "/codedownload")
	if error != OK:
		push_error("An error occurred in the HTTP request.")
		

func http_game_download_completed(result, response_code, headers, body):
	print(response_code) # check response code 200 otherwise error
	var response = parse_json(body.get_string_from_utf8())
	if response_code == 200:
		if response.data:
			emit_signal("game_id_retrieved", response.data.game)
			save_game(response.data)
			if response.data.assets:
				emit_signal("game_download_started", response.data.assets)
				for asset_id in response.data.assets:	
					http_download_asset(response.data.game, asset_id)
			else:
				emit_signal("game_download_started", null)
	else:
#		TODO replace with game offline
		emit_signal("game_download_started", null)

# download json of games and save it to the file user://gamses/games.var
# send signal when it is ready

func http_games_download():
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.connect("request_completed", self, "http_games_download_completed")
	var error = http_request.request(config.API + "/games/published")
	if error != OK:
		push_error("An error occurred in the HTTP request.")

func http_games_download_completed(result, response_code, headers, body):
	if response_code == 200:
		var response = parse_json(body.get_string_from_utf8())
		if response.data:
			save_games(response.data)
	#		print("DOWNLOADED")
			emit_signal("games_downloaded")
	else:
#		TODO replace with game offline
		emit_signal("games_offline")

func http_game_report(id, reason):
	var http_request = HTTPRequest.new()
	add_child(http_request)
	var body = JSON.print({
		"gameId": id,
		"reason": reason
	})
	var headers = ["Content-Type: application/json"]	
	http_request.connect("request_completed", self, "http_game_report_completed")
	var error = http_request.request(config.API + "/users/report", headers, true, HTTPClient.METHOD_POST, body)
	if error != OK:
		push_error("An error occurred in the HTTP request.")

func http_game_report_completed(result, response_code, headers, body):
	if response_code == 200:
		var response = parse_json(body.get_string_from_utf8())
		emit_signal("game_reported")
	else:
		emit_signal("game_report_error")

func http_game_analytics(gameId, pubGameId, data, downloadId):
	var http_request = HTTPRequest.new()
	add_child(http_request)
	var body = JSON.print({
		"game": gameId,
		"pubGame": pubGameId,
		"downloadId": downloadId,
		"data": data
	})
	var headers = ["Content-Type: application/json"]	
	http_request.connect("request_completed", self, "http_game_analytics_completed")
	var error = http_request.request(config.API + "/games/" + gameId + "/analytics", headers, true, HTTPClient.METHOD_POST, body)
	if error != OK:
		push_error("An error occurred in the HTTP request.")

func http_game_analytics_completed(result, response_code, headers, body):
	if response_code == 200:
		var response = parse_json(body.get_string_from_utf8())
		emit_signal("game_analytics_sent")
	else:
		emit_signal("game_analytics_error")



# END HTTP FUNCTIONS
