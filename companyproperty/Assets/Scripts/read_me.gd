extends Content

# Called when the node enters the scene tree for the first time.
func _enter_tree() -> void:
	pass

func _exit_tree() -> void: # When read me is closed, the node leaves the tree. so we can trigger stuff on close with this easy
	for index in 6:
		game.unlock_file()
	get_tree().current_scene.checking = false
	get_tree().current_scene.can_force_task = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
