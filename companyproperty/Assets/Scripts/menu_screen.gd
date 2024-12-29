extends CanvasLayer

@onready var title: TextureRect = $Background/Title
@onready var play: Button = $Background/Title/Play
@onready var options: Button = $Background/Title/Options
@onready var credits: Button = $Background/Title/Credits
@onready var exit: Button = $Background/Title/Exit
@onready var Volume: RichTextLabel = $Background/TextureRect/Options/MarginContainer2/HBoxContainer/RichTextLabel
@onready var check_button: CheckButton = $Background/OptionsT/Options/MarginContainer/HBoxContainer/CheckButton
@onready var h_slider: HSlider = $Background/OptionsT/Options/MarginContainer2/HBoxContainer/HSlider
@onready var optionsT: TextureRect = $Background/OptionsT
@onready var credits_t: TextureRect = $Background/CreditsT

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !title.visible:
		MainVisibleToggle()
	optionsT.visible = false;
	credits_t.visible = false;
	AudioManager.crtT = check_button.button_pressed;
	h_slider.value = 70.0
	AudioManager.volume = h_slider.value

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func MainVisibleToggle():
	title.visible = !title.visible;
	if title.visible:
		optionsT.visible = false;
		credits_t.visible = false;

func _on_play_pressed() -> void:
	get_tree().change_scene_to_packed(preload("res://Base.tscn"))


func _on_options_pressed() -> void:
	MainVisibleToggle()
	optionsT.visible = true;


func _on_credits_pressed() -> void:
	MainVisibleToggle()
	credits_t.visible = true;


func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_h_slider_value_changed(value: float) -> void:
	#volume slider
	AudioManager.volume = value;


func _on_check_button_toggled(toggled_on: bool) -> void:
	AudioManager.crtT = toggled_on;


func _on_button_pressed() -> void:
	MainVisibleToggle()
