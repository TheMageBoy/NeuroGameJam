extends Content

var tweet := "Hello there"
var tweet_index := 0
@onready var twitter: Control = $"."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if !enabled:
		return
	if event is InputEventKey:
		# do tweet stuff
		print(event.as_text())
		if tweet_index+1 == tweet.length() and !triggered:
			emit_signal("task_finish")
			return
