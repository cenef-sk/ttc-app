extends Control


var time_start = 0
var time_end = 0

func _ready():
	time_start = OS.get_unix_time()
	
func finished():
	time_end = OS.get_unix_time()
	
func duration():
	var time_elapsed = time_end - time_start
	print(time_elapsed)
