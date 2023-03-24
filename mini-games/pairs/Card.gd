extends Control

export var id = -1
export var img = ""
export var crop = [-1,-1,-1,-1]

onready var gameMng = get_node("/root/GameManagement")
onready var gameData = get_node("/root/GameData")

# flip tweens
onready var tween = get_node("Tween")
onready var tween2 = get_node("Tween2")
# unflip tweens
onready var tween3 = get_node("Tween3")
onready var tween4 = get_node("Tween4")

#onready var pairs = get_tree().get_root().find_node("Pairs2")

signal card_flipped
signal card_unflipped

var flipped = false
var allowed_flipping = true
var pair_match = false

# Called when the node enters the scene tree for the first time.
func _ready():
	var pairs = get_tree().get_root().find_node("PexesoUI", true, false)
	pairs.connect("allow_flipping", self, "_on_Allow_Flipping")
	pairs.connect("pair_match", self, "_on_Pair_Match")

func _on_Allow_Flipping(allowed):
	allowed_flipping = allowed
	if (allowed):
		if(flipped):
			unflip()

func _on_Pair_Match():
	if (flipped):
		pair_match = true
		$TextureRect3.visible = false

func _on_Card_gui_input(event):
	if (event is InputEventMouseButton && event.pressed && !flipped && allowed_flipping && !pair_match):
		flip()

func setText(text):
	get_node("TextureRect3/Label").text = text

func setTexture(asset_id, crop):
	
	var atlas = AtlasTexture.new()

	var texture_path = gameMng.get_asset(gameData.game_id, asset_id)
	
	if texture_path:
		var image = Image.new()
		image.load(texture_path)
		var t = ImageTexture.new()
		t.create_from_image(image)

		atlas.atlas = t;
		atlas.margin = Rect2(0, 0, 0, 0)
		atlas.region = crop
		$TextureRect3.texture = atlas
	

func flip():
	flipped = true
	emit_signal("card_flipped", id)
	var rect = get_node("TextureRect")
	tween.interpolate_property(rect, "rect_scale", Vector2(1, 1), Vector2(0, 1), 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween.start()
				
func unflip():
	if !pair_match:
		var label = get_node("TextureRect3/Label")
		var rect = get_node("TextureRect3")
		tween3.interpolate_property(rect, "rect_scale", Vector2(1, 1), Vector2(0, 1), 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN)
		tween3.start()
	else:
		$TextureRect3.hide()
	
func _on_Tween_tween_all_completed():
	var label = get_node("TextureRect3/Label")
	var rect = get_node("TextureRect3")
	tween2.interpolate_property(rect, "rect_scale", Vector2(0, 1), Vector2(1, 1), 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween2.start()

func _on_Tween3_tween_all_completed():
	var rect = get_node("TextureRect")
	tween4.interpolate_property(rect, "rect_scale", Vector2(0, 1), Vector2(1, 1), 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN)
	tween4.start()


func _on_Tween4_tween_all_completed():
	flipped = false
	emit_signal("card_unflipped")
