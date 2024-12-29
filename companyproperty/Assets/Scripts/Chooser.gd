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
	
	var texts = negatives.get_as_text();
	var negat = texts.split("\n");
	
	correct = randi() % 3
	
	var texts3 = positives.get_as_text();
	var posi = texts3.split("\n");
	var integer = randi() % (posi.size()-1)

	var integer2 = 0;
	
	var integer3 = randi() % (negat.size()-1)
	while (integer2 == integer3):
		integer2 = randi() % (negat.size()-1)
	
	if (correct == 0):
		button.text = posi[integer]
		button_2.text = negat[integer2]
		button_3.text = negat[integer3]
	elif (correct == 1):
		button_2.text = posi[integer]
		button.text = negat[integer2]
		button_3.text = negat[integer3]
	else:
		button_3.text = posi[integer]
		button.text = negat[integer2]
		button_2.text = negat[integer3]

	#print(integer)
	#print(texts2[integer])
	
	button.connect("pressed",Callable(self,"chosen").bind(0))
	button_2.connect("pressed",Callable(self,"chosen").bind(1))
	button_3.connect("pressed",Callable(self,"chosen").bind(2))

func chosen(val : int):
	if (val == correct):
		emit_signal("task_finish")
	else:
		emit_signal("task_fail")
