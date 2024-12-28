extends Node

var window_array = []
var quota = 10000
var rate = 10 # -quota per second
@export var progress_bar: Node = null	

func createWindow(size):
	var new_window = Panel.new()
	var panel_script = load("res://Assets/Scripts/UI_Window.gd")
	new_window.size = size
	new_window.set_script(panel_script)
	new_window.setup_window(3000)
	add_child(new_window)
	window_array.append(new_window)
	updateAllWindows()

func updateAllWindows():
	if window_array.size() == 0:
		return 
	var i = 0
	for window in window_array:
		window.z_index = i
		window.top = false
		i += 1
	window_array.back().top = true

#func _process(delta: float) -> void:
	#quota += -rate
	#progress_bar.value = quota

func deleteWindow(window): #deletes a window after passing itself in
	window_array.erase(window)
	window.queue_free()
	updateAllWindows()
	
func move_to_top(window):
	window_array.erase(window)
	window_array.append(window)
	updateAllWindows()

func failedTask(window):
	print("RAN OUT OF TIME ON TASK")
	deleteWindow(window)
