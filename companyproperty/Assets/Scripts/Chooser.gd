extends Content

@export var text : String

@onready var button: Button = $VBoxContainer/Button
@onready var button_2: Button = $VBoxContainer/Button2
@onready var button_3: Button = $VBoxContainer/Button3

var correct : int

# Called when the node enters the scene tree for the first time.
func _ready():
	var negatives = FileAccess.open("res://Assets/ChooserNegative.txt",FileAccess.READ)
	var positives = FileAccess.open("res://Assets/ChooserPositive.txt",FileAccess.READ)
	
	var texts = positives.get_as_text();
	var texts2 = texts.split("\n");
	
	var correct = randi() % 3
	
	var texts3 = negatives.get_as_text();
	var texts4 = texts3.split("\n");
	var integer = randi() % (texts4.size()-1)

	var integer2 = 0;
	
	var integer3 = randi() % (texts2.size()-1)
	while (integer2 == integer3):
		integer2 = randi() % (texts2.size()-1)
	
	if (correct == 0):
		button.text = texts4[integer]
		button_2.text = texts2[integer2]
		button_3.text = texts2[integer3]
	elif (correct == 1):
		button_2.text = texts4[integer]
		button.text = texts2[integer2]
		button_3.text = texts2[integer3]
	else:
		button_3.text = texts4[integer]
		button.text = texts2[integer2]
		button_2.text = texts2[integer3]

	#print(integer)
	#print(texts2[integer])
	
	button.connect("pressed",Callable(self,"chosen").bind(0))
	button_2.connect("pressed",Callable(self,"chosen").bind(1))
	button_3.connect("pressed",Callable(self,"chosen").bind(2))

func chosen(val : int):
	if (val == correct):
		emit_signal("task_finish")
	else:
		emit_signal("task_failed")
