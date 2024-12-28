extends Content

@export var text : String
@onready var rich_text_label_2: RichTextLabel = $HBoxContainer/VBoxContainer/VBoxContainer/RichTextLabel2

# Called when the node enters the scene tree for the first time.
func _ready():
	var file = FileAccess.open("res://Assets/Tweets.txt",FileAccess.READ)
	var texts = file.get_as_text();
	var texts2 = texts.split("\n");
	var integer = randi() % (texts2.size()-1);
	rich_text_label_2.text = texts2[integer];
	rich_text_label_2.visible_characters = 0;

func _input(event: InputEvent):
	if event is InputEventKey:
		rich_text_label_2.visible_characters += 1;
		if rich_text_label_2.visible_characters >= rich_text_label_2.text.length() and !triggered:
			triggered = true
			emit_signal("task_finish");