extends Camera2D


func _ready():
	$Tween.interpolate_property(self, "zoom", self.zoom + Vector2(1, 1), self.zoom, 2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
