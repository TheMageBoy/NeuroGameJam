extends Button

@export var program_number: int = 0;

func _pressed():
	get_tree().current_scene.changeWindows(program_number)
