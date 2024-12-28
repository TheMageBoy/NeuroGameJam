extends Node

var uiwindow = null

func _ready():
	var button = Button.new()
	#button.text = "Click me"
	button.pressed.connect(self._button_pressed)
	add_child(button)

func _button_pressed():
	print("Hello world!")
