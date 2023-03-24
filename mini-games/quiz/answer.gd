extends Control


onready var tween = get_node("Tween")

signal answer_selected
var is_correct = false
var is_answer_selected = false
var stop_interaction = false

# Called when the node enters the scene tree for the first time.
func _ready():
	var quiz = get_tree().get_root().find_node("Quiz", true, false)
	quiz.connect("answer_ready", self, "_on_Answer_Ready")

func _on_Answer_Ready():
	stop_interaction = true
	if is_answer_selected:
		if is_correct:
			tween.interpolate_property($TextureRect, "modulate", modulate, Color("#74ac78"), 0.5, Tween.TRANS_LINEAR, Tween.EASE_OUT)			
		else:
			tween.interpolate_property($TextureRect, "modulate", modulate, Color("#c57a7a"), 0.5, Tween.TRANS_LINEAR, Tween.EASE_OUT)
		tween.start()		
	else:
		if is_correct:
			tween.interpolate_property($TextureRect, "modulate", modulate, Color("#74ac78"), 0.5, Tween.TRANS_LINEAR, Tween.EASE_OUT)			
			tween.start()		
		

func setAnswer(text, is_correct):
	$Label.text = text
	self.is_correct = is_correct

func _on_Answer_gui_input(event):
	if (event is InputEventMouseButton && event.pressed && !stop_interaction):
		is_answer_selected = true
		emit_signal("answer_selected", is_correct)
