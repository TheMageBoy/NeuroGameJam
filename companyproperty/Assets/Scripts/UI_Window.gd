extends Node

var has_lifespan = false # timed events
var lifespan = 0

var dragging = false
var drag_pos = Vector2()
var offset = Vector2()

var mouse_over = false;
var last_higlihted = false; # for if input will register to the current window

var x_button = null

@onready var node: Node = $".."
@onready var panel: Panel = $"."

func _ready():
	# X
	x_button = Button.new()
	x_button.pressed.connect(self.x_button_pressed)
	add_child(x_button)

func _input(event: InputEvent):
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed and !dragging && mouse_within(get_viewport().get_mouse_position()):
			offset = panel.get_screen_position() - get_viewport().get_mouse_position();
			dragging = true;#Toggle Dragging when clicked
			#print("Clicking");

func _process(delta: float):#I hope this is equivalent to update?
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
	return point.x >= x and point.x <= x2 and point.y >= y and point.y <= y2

# ------------------------------------------
# X Button
# ------------------------------------------

func x_button_pressed():
	self.queue_free()
