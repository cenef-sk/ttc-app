extends TextureRect

export var imageIndex = 0
signal timeline_change

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func get_drag_data(position):
	var data = {}
	
	data["origin"] = self
	data["origin_texture"] = texture
	data["origin_image_index"] = imageIndex
	
	var drag_texture = TextureRect.new()
	drag_texture.expand = true
	drag_texture.texture = texture
	drag_texture.rect_size = Vector2(300, 300)
	
	var control = Control.new()
	control.add_child(drag_texture)
	drag_texture.rect_position = -0.5 * drag_texture.rect_size
	set_drag_preview(control)
	
	return data
	
func can_drop_data(position, data):
	return true
	
func drop_data(position, data):
	data["origin"].texture = texture
	texture = data["origin_texture"]
	data["origin"].imageIndex = imageIndex	
	imageIndex = data["origin_image_index"] 
	emit_signal("timeline_change")

	
