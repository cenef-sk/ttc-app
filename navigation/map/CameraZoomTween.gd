extends Camera2D


func _ready():
	$"..".connect("intro_done", self, "showMap")

func showMap():	
	$Tween.interpolate_property(self, "zoom", self.zoom + Vector2(1, 1), self.zoom, 2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
