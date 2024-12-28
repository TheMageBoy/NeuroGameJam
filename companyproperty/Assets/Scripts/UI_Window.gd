extends Node

class_name UI_Window

var has_lifespan = false
var lifespan = 0 #miliseconds; 0 if no lifespan

var dragging = false
var drag_pos = Vector2()
var offset = Vector2()

var mouse_over = false;
var last_higlihted = false; # for if input will register to the current window

var x_button = null
var progress_bar = null

@onready var node: Node = $".."
@onready var panel: Panel = $"."

var top = false; #if this is the topmost

func setup_window(time):
	lifespan = time
	
	x_button = Button.new()
	x_button.text = "X"
	x_button.pressed.connect(self.x_button_pressed)
	add_child(x_button)
	
	if !has_lifespan:
		call_deferred("_setup_progress_bar", time) # this is here because otherwise it odesnt calc button size and return s 0

func _setup_progress_bar(time):
	var button_size = x_button.size.x
	print("Button size:", button_size)
	
	# Create the progress bar
	progress_bar = ProgressBar.new()
	progress_bar.size.x = self.size.x - button_size
	progress_bar.position.x = button_size
	
	# Configure progress bar lifespan
	if time > 0:
		has_lifespan = true
		progress_bar.max_value = time

	add_child(progress_bar)

func _input(event: InputEvent):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed and !dragging and mouse_within(get_viewport().get_mouse_position()):
			offset = panel.get_screen_position() - get_viewport().get_mouse_position();
			dragging = true;#Toggle Dragging when clicked

func _process(delta: float):#I hope this is equivalent to update?
	if has_lifespan:
		lifespan += -1
		if lifespan <= 0:
			get_tree().current_scene.failedTask(self)
		else:
			progress_bar.value = lifespan
		
	if !Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		dragging = false;
	if dragging == true:
		drag_pos = get_viewport().get_mouse_position() + offset;#Drag position is set to mouse position
		panel.global_position = drag_pos#Thus, set transform position to drag position
		
func mouse_within(point):
	var x = panel.global_position.x
	var y = panel.global_position.y
	var x2 = x + self.size.x
	var y2 = y + self.size.y
	#TODO: make a check if it is the topmost
	return point.x >= x and point.x <= x2 and point.y >= y and point.y <= y2

# ------------------------------------------
# X Button
# ------------------------------------------

func x_button_pressed():
	#autofails if you try to X out of a task window (failed task closes it)
	if has_lifespan:
		get_tree().current_scene.failedTask(self)
	else:
		get_tree().current_scene.deleteWindow(self)
