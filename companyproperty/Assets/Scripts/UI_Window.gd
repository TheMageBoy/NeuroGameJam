extends Node

var has_lifespan = false # timed events
var lifespan = 0

var dragging = false
var drag_pos = Vector2()

func _input(event: InputEvent):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			get_tree().current_scene()
