extends Node

var has_lifespan = false # timed events
var lifespan = 0

var dragging = false
var drag_pos = Vector2()


@onready var node: Node = $".."
@onready var panel: Panel = $"."

func _input(event: InputEvent):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			dragging = true;#Toggle Dragging when clicked
			#print("Clicking");

func _process(delta: float):#I hope this is equivalent to update?
	if !Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		dragging = false;
	if dragging == true:
		drag_pos = get_viewport().get_mouse_position();#Drag position is set to mouse position
		panel.position = drag_pos#Thus, set transform position to drag position
