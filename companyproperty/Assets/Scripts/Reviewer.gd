extends Content

@export var text : String

@onready var review: RichTextLabel = $HBoxContainer/VBoxContainer/RichTextLabel
@onready var button: Button = $HBoxContainer/VBoxContainer/HBoxContainer/Button
@onready var button_2: Button = $HBoxContainer/VBoxContainer/HBoxContainer/Button2
@onready var likes: RichTextLabel = $HBoxContainer/VBoxContainer/HBoxContainer/RichTextLabel
@onready var dislikes: RichTextLabel = $HBoxContainer/VBoxContainer/HBoxContainer/RichTextLabel2

var negative : bool
var outcome : bool

var negativeswords : PackedStringArray = ["good","amazing","great","awesome","works"]

# Called when the node enters the scene tree for the first time.
func _ready():
	var file = FileAccess.open("res://Assets/Reviews.txt",FileAccess.READ)
	
	var texts = file.get_as_text();
	var texts2 = texts.split("\n");
	var integer = randi() % (texts2.size()-1);
	#print(integer)
	#print(texts2[integer])
	review.text = texts2[integer];
	
	for words in negativeswords:
		if review.text.find(words):
			negative = true;
		else:
			negative = false;
	
	button.connect("pressed",Callable(self,"like"))
	button_2.connect("pressed",Callable(self,"dislike"))

func like():
	outcome = true;
	likes.text = var_to_str(str_to_var(likes.text)+1)
	if (negative == outcome):
		emit_signal("task_finish")
	else:
		emit_signal("task_failed")


func dislike():
	outcome = false;
	dislikes.text = var_to_str(str_to_var(likes.text)+1)
	if (negative == outcome):
		emit_signal("task_finish")
	else:
		emit_signal("task_failed")
