extends Node

var window_array = []
var quota = 10000
var rate = 10 # -quota per second
@export var progress_bar: Node = null
@onready var window_node: Control = $WindowNode

const UI_WINDOW = preload("res://Assets/Scenes/UI_Window.tscn")

func createWindow(size, is_task : bool):
	var new_window = UI_WINDOW.instantiate()
	#var panel_script = load("res://Assets/Scripts/UI_Window.gd")
	new_window.size = size
	new_window.has_lifespan = is_task
	
	#new_window.set_script(panel_script)
	new_window.setup_window(3000)
	window_node.add_child(new_window)
	new_window.progress_bar.show_percentage = is_task
	window_array.append(new_window)
	#updateAllWindows()

#func #updateAllWindows():
#	if window_array.size() == 0:
#		return 
#	var i = 0
#	for window in window_array:
#		window.z_index = i
#		window.top = false
#		i += 1
#	
#	window_array.back().top = true

#func _process(delta: float) -> void:
	#quota += -rate
	#progress_bar.value = quota

func deleteWindow(window): #deletes a window after passing itself in
	window_array.erase(window)
	window.queue_free()
	#updateAllWindows()
	
func move_to_top(window):
	window_array.erase(window)
	window_array.append(window)
	#updateAllWindows()

func failedTask(window):
	print("RAN OUT OF TIME ON TASK")
	deleteWindow(window)


func _on_task_window_button_pressed() -> void:
	createWindow(Vector2(100,100), true)

func _on_text_window_button_pressed() -> void:
	createWindow(Vector2(256,256), false)
