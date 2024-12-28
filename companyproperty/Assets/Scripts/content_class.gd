extends Control
class_name content # extend this to a control node otherwise error

signal task_finish # call this when task complete using "emit_signal("task_finish")"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
