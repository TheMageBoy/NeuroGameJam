extends Content

@export var text : String

@onready var button: Button = $HBoxContainer/VBoxContainer/Button
@onready var button_2: Button = $HBoxContainer/VBoxContainer/Button2
@onready var button_3: Button = $HBoxContainer/VBoxContainer/Button3

var correct : int
const LAVALAMP = preload("res://Assets/Images/lavalamp.png")
const EVIL_PLUSH_2_0 = preload("res://Assets/Images/EvilPlush2.0.webp")
const NEURO_PLUSH_2_0 = preload("res://Assets/Images/NeuroPlush2.0.webp")
@onready var productimg: TextureRect = $HBoxContainer/TextureRect

var products := [EVIL_PLUSH_2_0,NEURO_PLUSH_2_0,LAVALAMP]
# Called when the node enters the scene tree for the first time.
func _ready():
	var negatives = FileAccess.open("res://Assets/ChooserNegative.txt",FileAccess.READ)
	var positives = FileAccess.open("res://Assets/ChooserPositive.txt",FileAccess.READ)
	
	productimg.texture = products[randi() % (products.size())]
	
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
	if !enabled:
		return
	if (val == correct):
		emit_signal("task_finish")
	else:
		emit_signal("task_fail")
