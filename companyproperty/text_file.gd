extends Content

@onready var rtl: RichTextLabel = $RichTextLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rtl.meta_clicked.connect(Callable(game, "meta_clicked"))
	await get_tree().process_frame
	content_self.progress_bar.show_percentage = true

var load_speed := 4.0
func _process(delta: float) -> void:
	if content_self.progress_bar.value != 100:
		content_self.progress_bar.value += delta * load_speed
		load_speed = clampf(load_speed, 8.0, 32.0)
		load_speed += randf_range(-4, 4)
		if content_self.progress_bar.value > 95:
			load_speed -= 4
	elif !triggered:
		triggered = true
		rtl.text = data
