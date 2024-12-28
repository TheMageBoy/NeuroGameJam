extends Button

func _pressed():
	get_tree().current_scene.createWindow(Vector2(100,100));
