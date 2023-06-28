extends Control

var step = 1
const timer = 0.5
const maxValue = 100
export var total = 15

func _ready():
	print("READY")
	setTimer(total)
	
func setTimer(time):
	total = time;
	step = maxValue/(total/timer)
	$ProgressBar.value = 0
	
	
func start():
	$Timer.start()

func stop():
	$Timer.stop()

func _on_Timer_timeout():
	$ProgressBar.value = $ProgressBar.value + step
	if ($ProgressBar.value >= maxValue):
		$Timer.stop()
		print("DONE")
		SceneTransition.change_scene("res://navigation/map/map.tscn")
		$Stopwatch.finished()
		$Stopwatch.duration()
