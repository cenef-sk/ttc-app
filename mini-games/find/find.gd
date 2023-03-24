extends Node2D

onready var gameMng = get_node("/root/GameManagement")
onready var gameData = get_node("/root/GameData")
onready var utils = get_node("/root/Utils")

var circle = preload("res://mini-games/find/circle2.tscn")

var events = {}
var last_drag_distance = 0
var oy_clamp = 0;
var ox_clamp = 0;

var y_clamp = 0;
var x_clamp = 0;
var ratio = 1;

var WEB_HEIGHT = 500.0

var explanation

# Called when the node enters the scene tree for the first time.
func _ready():
	var asset_id = gameData.activity.content.asset

	var texture_path = gameMng.get_asset(gameData.game_id, asset_id)

	if texture_path:
		var image = Image.new()
		image.load(texture_path)
		var height = image.get_height()
		var width = image.get_width()
		var webRatio = height/WEB_HEIGHT
		var xRatio = 1080.0/width
		var yRatio = 1920.0/height
		ratio = max(xRatio, yRatio)
#			print(xRatio)
#			print(yRatio)
		var t = ImageTexture.new()
		t.create_from_image(image)
		$Sprite.texture = t
		$Sprite.scale.x = ratio
		$Sprite.scale.y = ratio
	
		var y_camera = $Camera2D.get_viewport_rect().size.y/2
		oy_clamp = ($Sprite.get_rect().size.y * ratio)/2 - y_camera
		y_clamp = oy_clamp
		var x_camera = $Camera2D.get_viewport_rect().size.x/2
		ox_clamp = ($Sprite.get_rect().size.x * ratio)/2 - x_camera
		x_clamp = ox_clamp
		print(ox_clamp)
		print("x")
		print($Sprite.get_rect().size.x)
		print(image.get_width())

		var poi = gameData.next_poi()
		print(gameData.poi_index)
		print(poi)
		if poi:
			var c = circle.instance()
			c.position.x = poi.position[0]*webRatio-($Sprite.get_rect().size.x)/2 
			c.position.y = poi.position[1]*webRatio-($Sprite.get_rect().size.y)/2
			c.scale.x = c.scale.x / ratio
			c.scale.y = c.scale.y / ratio
			$Sprite.add_child(c)
			$CanvasLayer/VBoxContainer/Label.text = poi.question
			c.connect("poi_found", self, "_on_Poi_Found")
#			c.show_check()
			explanation = poi.explanation
		else:
	#		No poi provided
			SceneTransition.change_scene("res://navigation/map/map.tscn")
	
func _on_Poi_Found():
	gameData.add_poi(true)
	if explanation:
		$CanvasLayer/Explanation.set_explanation(explanation)
		$CanvasLayer/Explanation.visible = true
		$CanvasLayer/Explanation.connect("explanation_closed", self, "_on_Explanation_Closed")
	else:
		_on_Explanation_Closed()

func create_results():
	var res = ""
	var total = gameData.found_pois.size()
	res += "Úlohu si úspešne splnil."
	res += "\n"
	res += "Nájdených bodov: " + String(total)
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
	$CanvasLayer/Explanation.visible = false
	if gameData.has_next_poi():
		SceneTransition.change_scene("res://mini-games/find/find.tscn")
	else:
		$CanvasLayer/Results.set_results(create_results())
		$CanvasLayer/Results.connect("results_closed", self, "_on_Results_Closed")
		$CanvasLayer/Results.visible = true

func _unhandled_input(event):
	if event is InputEventScreenTouch:
		if event.pressed:
			events[event.index] = event
		else:
			events.erase(event.index)
			
			
	if event is InputEventScreenDrag:
		events[event.index] = event
		if events.size() == 1:
			$Camera2D.position -= event.relative * $Camera2D.zoom.x
			$Camera2D.position.x = clamp($Camera2D.position.x, -x_clamp, x_clamp)
			$Camera2D.position.y = clamp($Camera2D.position.y, -y_clamp, y_clamp)
#		elif events.size() == 2:
#			var drag_distance = events[0].position.distance_to(events[1].position)
#			if abs(drag_distance - last_drag_distance) > zoom_sensitivity:
#				var new_zoom = (1 + zoom_speed) if drag_distance < last_drag_distance else (1 - zoom_speed)
#				new_zoom = clamp($Camera2D.zoom.x * new_zoom, min_zoom, max_zoom)
#				$Camera2D.zoom = Vector2.ONE * new_zoom
#				last_drag_distance = drag_distance
#				$Camera2D.position.x = clamp($Camera2D.position.x, -x_clamp, x_clamp)
#				$Camera2D.position.y = clamp($Camera2D.position.y, -y_clamp, y_clamp)
#

func _process(delta):
	if Input.is_action_pressed("ui_right"):
		$Camera2D.position.x += 1000 * delta
		$Camera2D.position.x = clamp($Camera2D.position.x, -x_clamp, x_clamp)
	if Input.is_action_pressed("ui_left"):
		$Camera2D.position.x -= 1000 * delta
		$Camera2D.position.x = clamp($Camera2D.position.x, -x_clamp, x_clamp)
	if Input.is_action_pressed("ui_up"):
		$Camera2D.position.y -= 1000 * delta
		$Camera2D.position.y = clamp($Camera2D.position.y, -y_clamp, y_clamp)
	if Input.is_action_pressed("ui_down"):
		$Camera2D.position.y += 1000 * delta
		$Camera2D.position.y = clamp($Camera2D.position.y, -y_clamp, y_clamp)


