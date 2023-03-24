extends Node2D

onready var gameData = get_node("/root/GameData")
onready var gameMng = get_node("/root/GameManagement")

signal intro_done

var circle = preload("res://navigation/map/circle.tscn")

var events = {}
var last_drag_distance = 0
var oy_clamp = 0;
var ox_clamp = 0;

var y_clamp = 0;
var x_clamp = 0;
var ratio = 1;

var WEB_HEIGHT = 500.0

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("intro_done", self, "showMap")
	if (gameData.game.activities.size() == gameData.finished_activities.size()):
		if (gameData.game.has("endText") and gameData.game.endText):
			if !gameData.end_shown: 
				$CanvasLayer/End/Label.text = gameData.game.endText
				$CanvasLayer/End.visible = true
				gameData.endShown()
		
	if (gameData.game.has("introText") and gameData.game.introText):
		if !gameData.intro_shown and !gameData.finished_activities.size() and !gameData.unlocked_activities.size(): 
			$CanvasLayer/Intro/Label.text = gameData.game.introText
			$CanvasLayer/Intro.visible = true
			gameData.introShown()
		else:
			emit_signal("intro_done")
	else:
		emit_signal("intro_done")
	
func showMap():
	if gameData.game.has("bg") and gameData.game.bg.has("asset") and gameData.game.bg.asset:
		var asset_id = gameData.game.bg.asset._id
		var pointer = gameData.game.bg.selectedPointer
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
			
			for index in gameData.game.activities.size():
				var poi = gameData.game.activities[index]
				var c = circle.instance()
				c.label = String(index + 1)
				c.pointer = pointer
				if gameData.finished_activities.count(index):
					c.show_check()
				if poi.has("config") && poi.config.has("inPass") && poi.config.has("inPassDesc"):
					if !gameData.unlocked_activities.count(index):
						c.show_lock(poi.config.inPass, poi.config.inPassDesc)
						c.connect("activity_locked", self, "_on_Activity_Locked")
				c.position.x = poi.position[0]*webRatio-($Sprite.get_rect().size.x)/2 
				c.position.y = poi.position[1]*webRatio-($Sprite.get_rect().size.y)/2
				c.set_activity_id(index)
				c.scale.x = c.scale.x / ratio
				c.scale.y = c.scale.y / ratio
				$Sprite.add_child(c)
	
func _on_Activity_Locked(in_pass, in_pass_desc, activity_index):
	$CanvasLayer/Locked.set_data(in_pass, in_pass_desc, activity_index)
	$CanvasLayer/Locked.show()

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

func _on_Intro_gui_input(event):
	if (event is InputEventMouseButton && event.pressed):
		$CanvasLayer/Intro.visible = false
		emit_signal("intro_done")


func _on_End_gui_input(event):
	if (event is InputEventMouseButton && event.pressed):
		$CanvasLayer/End.visible = false
#		emit_signal("intro_done")
