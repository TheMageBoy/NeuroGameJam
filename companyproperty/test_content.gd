extends Content


# Called when the node enters the scene tree for the first time.
func _enter_tree() -> void:
	$RichTextLabel.text = data

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
