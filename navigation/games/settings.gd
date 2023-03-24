extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	selectLng()
	$Bg/OptionButton.theme = Theme.new()
	$Bg/OptionButton.theme.default_font = DynamicFont.new()
	$Bg/OptionButton.theme.default_font.font_data = load("res://assets/fonts/Signika-Regular.ttf")
	$Bg/OptionButton.theme.get_font("font", "OptionButton").size = 80;
	$Bg/CheckButton.pressed = Config.denyAnalytics

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func selectLng():
	
	match Config.lng:
		"sk": $Bg/OptionButton.selected = 0
		"en": $Bg/OptionButton.selected = 1
		"cs": $Bg/OptionButton.selected = 2
		"pl": $Bg/OptionButton.selected = 3	
	

func _on_Button_gui_input(event):
	if (event is InputEventMouseButton && event.pressed):
		SceneTransition.change_scene("res://navigation/games/games2.tscn")


func _on_OptionButton_item_selected(index):
	if (index == 0):
		Config.setLng("sk")
	if (index == 1): 
		Config.setLng("en")
	if (index == 2): 
		Config.setLng("cs")
	if (index == 3): 
		Config.setLng("pl")


func _on_CheckButton_toggled(button_pressed):
	Config.setDenyAnalytics(button_pressed)


func _on_Button2_pressed():
	Config.resetBlocked()
	SceneTransition.change_scene("res://navigation/games/games2.tscn")
