extends Node

var uiwindow = null

func _ready():
	var button = Button.new()
	#button.text = "Click me"
	button.pressed.connect(self._button_pressed)
	add_child(button)
	uiwindow = get_parent() #temporary; pass in in init
	
func initialize(parent):
	uiwindow = parent

func _button_pressed():
	uiwindow.close();
