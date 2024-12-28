extends Node

var has_lifespan = false # timed events
var lifespan = 0

var dragging = false
var drag_pos = Vector2()

func _input(event: InputEvent):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			dragging = !dragging;#Toggle Dragging when clicked

func _draw():#I hope this is equivalent to update?
	if dragging == true:
		drag_pos = get_viewport().get_mouse_position();#Drag position is set to mouse position
		#Thus, set transform position to drag position
