extends Content

@export var text : String
@onready var rich_text_label_2: RichTextLabel = $HBoxContainer/VBoxContainer/VBoxContainer/RichTextLabel2

var visible_characters : int
var finishedtext : String

# Called when the node enters the scene tree for the first time.
func _ready():
	var file = FileAccess.open("res://Assets/Tweets.tres",FileAccess.READ)
	var texts = file.get_as_text();
	var texts2 = texts.split("\n");
	var integer = randi() % (texts2.size()-1);
	finishedtext = texts2[integer];
	visible_characters = 0;

func _input(event: InputEvent):
	if event is InputEventKey:
		if (rich_text_label_2.text != finishedtext):
			rich_text_label_2.text = finishedtext
		visible_characters += 1
		rich_text_label_2.visible_characters = visible_characters;
		if rich_text_label_2.visible_characters >= rich_text_label_2.text.length() and !triggered:
			triggered = true
			emit_signal("task_finish");
