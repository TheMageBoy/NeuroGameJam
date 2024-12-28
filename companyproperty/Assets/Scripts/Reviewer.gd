extends Content

@export var text : String

@onready var review: RichTextLabel = $HBoxContainer/VBoxContainer/RichTextLabel
@onready var button: Button = $HBoxContainer/VBoxContainer/HBoxContainer/Button
@onready var button_2: Button = $HBoxContainer/VBoxContainer/HBoxContainer/Button2

var negative : bool
var outcome : bool

var negativeswords : PackedStringArray = ["sucks","garbage","shit","fuck","shot","screw"]

signal next
var score := 0
func _ready():
	button.connect("pressed",Callable(self,"like"))
	button_2.connect("pressed",Callable(self,"dislike"))
	for _index in 3:
		var file = FileAccess.open("res://Assets/Reviews.txt",FileAccess.READ)
		
		var texts = file.get_as_text();
		var texts2 = texts.split("\n");
		var integer = randi() % (texts2.size()-1);
		#print(integer)
		#print(texts2[integer])
		review.text = texts2[integer];
		
		for words in negativeswords:
			if (review.text.to_lower().contains(words)):
				negative = true;
			else:
				negative = false;
		await next
	finish_review()

func like():
	if (negative == true):
		score += 1
	emit_signal("next")

func dislike():
	if (negative == false):
		score += 1
	emit_signal("next")


func finish_review():
	if score > 2:
		emit_signal("task_finish")
	else:
		emit_signal("task_fail")
	button.disabled = true
	button_2.disabled = true
