extends Control


onready var sv1 = $VBoxContainer/SlotWrapper
onready var sv2 = $VBoxContainer/SlotWrapper2
onready var sv3 = $VBoxContainer/SlotWrapper3
onready var sv4 = $VBoxContainer/SlotWrapper4
onready var sv5 = $VBoxContainer/SlotWrapper5

onready var gameMng = get_node("/root/GameManagement")
onready var gameData = get_node("/root/GameData")
onready var utils = get_node("/root/Utils")

# Called when the node enters the scene tree for the first time.
func _ready():

	$VBoxContainer/Label.text = gameData.activity.content.task
	
	var svs = [sv1, sv2, sv3, sv4, sv5] 
	for index in svs.size():
		svs[index].index = index
	
	var sh_svs = utils.shuffleList(svs)
	while(ordered(sh_svs)):
		sh_svs = utils.shuffleList(svs)
	
	var ii = gameData.activity.content.items
	for index in ii.size():
		var sv = sh_svs[index]
		if ii[index]:
			sv.setTimelineImageTexture(getTexture(ii[index], null))
		sv.setImageIndex(index)
		
	var items = get_tree().get_nodes_in_group("timeline_item")
	for item in items:
		item.connect("timeline_change", self, "on_Timeline_Change")

func ordered(svs):
	for index in svs.size():
		if svs[index].index != index:
			return false
	return true

func getTexture(asset_id, crop):
	
	var atlas = AtlasTexture.new()

	var texture_path = gameMng.get_asset(gameData.game_id, asset_id)
	
	if texture_path:
		var image = Image.new()
		image.load(texture_path)
		var t = ImageTexture.new()
		t.create_from_image(image)

		atlas.atlas = t;
		atlas.margin = Rect2(0, 0, 0, 0)
#		atlas.region = crop
		atlas.region = Rect2(0, 0, image.get_width(), image.get_height())
		return atlas

func on_Timeline_Change():
	gameData.pair_flip()
	if (sv1.checkOrder() and sv2.checkOrder() and sv3.checkOrder() and sv4.checkOrder() and sv5.checkOrder()):
		var explanation = gameData.activity.content.explanation
		if explanation:
			$Explanation.set_explanation(explanation)
			$Explanation.connect("explanation_closed", self, "_on_Explanation_Closed")
			$Explanation.visible = true
		else:
			$Results.set_results(create_results())
			$Results.connect("results_closed", self, "_on_Results_Closed")
			$Results.visible = true
	else:
		print("NOT YET.")

func create_results():
	var res = ""
	var total = gameData.pair_flips
	res += "Úlohu si úspešne splnil."
	res += "\n"
	res += "Celkový počet presunov: " + String(total)
	res += "\n"
	if gameData.activity.config && gameData.activity.config.has("outPass"):
		if gameData.activity.config.outPass:
			res += "\n"
			res += "Získal si heslo: " + gameData.activity.config.outPass
			res += "\n"
	return res

func _on_Results_Closed():
	gameData.activty_finished()
	gameData.reset_activity()
	SceneTransition.change_scene("res://navigation/map/map.tscn")

func _on_Explanation_Closed():
	$Explanation.visible = false
	$Results.set_results(create_results())
	$Results.connect("results_closed", self, "_on_Results_Closed")
	$Results.visible = true

