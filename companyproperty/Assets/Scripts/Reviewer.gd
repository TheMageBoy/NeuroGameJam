extends Content

@export var text : String

@onready var review: RichTextLabel = $HBoxContainer/VBoxContainer/RichTextLabel
@onready var button: Button = $HBoxContainer/VBoxContainer/HBoxContainer/Button
@onready var button_2: Button = $HBoxContainer/VBoxContainer/HBoxContainer/Button2

var negative : bool
var outcome : bool

var negativeswords : PackedStringArray = ["sucks","garbage","shit","fuck","shot","screw","crashes","scam","No point","Unfollowing","butt","DELETE","Marry me","Fuck","come back to this?","drain","regret","disappointing","PLEASE","sold","used to be","was a mistake","die","bumbling","idiots","she can lose","Stupid","dumb","follower count reaches 0","Good for nothing","piece of scrap","brainless","FUCK","disappointment","delete herself","worthless","lose in a single minute"]

signal next
var score := 0
func _ready():
	button.connect("pressed",Callable(self,"like"))
	button_2.connect("pressed",Callable(self,"dislike"))
	for _index in 3:
		var file = FileAccess.open("res://Assets/Reviews.tres",FileAccess.READ)
		
		var texts = file.get_as_text();
		var texts2 = texts.split("\n");
		var integer = randi() % (texts2.size()-1);
		#print(integer)
		#print(texts2[integer])
		review.text = texts2[integer];
		negative = false;
		for words in negativeswords:
			if (review.text.contains(words)):
				negative = true;
		await next
	finish_review()

func like():
	if (negative == false):
		score += 1
		#print("correct")
	#else:
		#print("incorrect")
	emit_signal("next")

func dislike():
	if (negative == true):
		#print("correct")
		score += 1
	#else:
		#print("incorrect")
	emit_signal("next")


func finish_review():
	#print(score)
	if score > 2:
		emit_signal("task_finish")
	else:
		emit_signal("task_fail")
	button.disabled = true
	button_2.disabled = true
