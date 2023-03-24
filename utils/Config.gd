extends Node


#var API = "http://192.168.0.166:3070/api"
var API = "https://curator.touchtheculture.eu/api"
#var API = "http://127.0.0.1:3070/api"
var lng = "sk"
var denyAnalytics = false

var blockedUsers = []
var blockedContent = []

# Called when the node enters the scene tree for the first time.
func _ready():
	print("blockedUsers")
	print(blockedUsers)
	pass # Replace with function body.

func setLng(sLng):
	lng = sLng
	TranslationServer.set_locale(sLng)
	GameManagement.save_config(save())

func setDenyAnalytics(dAnal):
	denyAnalytics = dAnal
	GameManagement.save_config(save())

func resetBlocked():
	blockedUsers = []	
	blockedContent = []	
	GameManagement.save_config(save())
	
func blockUser(userId):
	print("blockedUsers")
	print(blockedUsers)
	blockedUsers.push_back(userId)
	GameManagement.save_config(save())

func blockContent(gameId):
	blockedContent.push_back(gameId)
	GameManagement.save_config(save())

func save():
	return {
		"lng": lng,
		"denyAnalytics": denyAnalytics,
		"blockedUsers": blockedUsers,
		"blockedContent": blockedContent
	}
	
func load(data):
	if (data.has('lng')):
		lng = data.lng;
		TranslationServer.set_locale(lng)
	if (data.has('denyAnalytics')):
		denyAnalytics = data.denyAnalytics
	if (data.has('blockedUsers')):
		blockedUsers = data.blockedUsers
	if (data.has('blockedContent')):
		blockedContent = data.blockedContent
