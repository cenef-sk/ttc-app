extends TextureRect

export var index = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func setTimelineImageTexture(texture):
	$TimelineImage.texture = texture
	
func setImageIndex(index):
	$TimelineImage.imageIndex = index

func checkOrder():
	return $TimelineImage.imageIndex == index
