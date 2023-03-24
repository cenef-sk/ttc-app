extends CanvasLayer

func change_scene(target: String) -> void:
	var player = get_node("AnimationPlayer")
	player.play("dissolve")
	yield(player, "animation_finished")
	get_tree().change_scene(target)
	player.play_backwards("dissolve")
