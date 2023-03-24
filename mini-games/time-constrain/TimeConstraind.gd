extends Control

var step = 1
const timer = 0.5
const maxValue = 100
export var total = 7

func _ready():
	print("READY")
	step = maxValue/(total/timer)
	$ProgressBar.value = 0
	$Timer.start()


func _on_Timer_timeout():
	print("TIMEOUT")
	$ProgressBar.value = $ProgressBar.value + step
	if ($ProgressBar.value >= maxValue):
		$Timer.stop()
		print("DONE")
		SceneTransition.change_scene("res://navigation/map/map.tscn")
		$Stopwatch.finished()
		$Stopwatch.duration()
