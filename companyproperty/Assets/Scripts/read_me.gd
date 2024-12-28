extends Content

# Called when the node enters the scene tree for the first time.
func _enter_tree() -> void:
	pass

func _exit_tree() -> void:
	for index in 2:
		get_tree().current_scene.unlock_file()
		get_tree().current_scene.checking = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
