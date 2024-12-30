extends CanvasLayer

@onready var title: TextureRect = $Background/Title
@onready var Volume: RichTextLabel = $Background/OptionsT/Options/MarginContainer2/HBoxContainer/RichTextLabel
@onready var check_button: CheckButton = $Background/OptionsT/Options/MarginContainer/HBoxContainer/CheckButton
@onready var h_slider: HSlider = $Background/OptionsT/Options/MarginContainer2/HBoxContainer/HSlider
@onready var h_slider1: HSlider = $Background/OptionsT/Options/MarginContainer4/HBoxContainer/HSlider
@onready var h_slider2: HSlider = $Background/OptionsT/Options/MarginContainer5/HBoxContainer/HSlider
@onready var optionsT: TextureRect = $Background/OptionsT
@onready var credits_t: TextureRect = $Background/CreditsT
const WIND_44100_27055 = preload("res://Assets/Sounds/BGM/wind_44100-27055.mp3")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioManager.play_bgm(WIND_44100_27055)
	if !title.visible:
		MainVisibleToggle()
	optionsT.visible = false;
	credits_t.visible = false;
	AudioManager.crtT = check_button.button_pressed;
	h_slider.value = 70.0
	h_slider1.value = 70.0
	h_slider2.value = 70.0
	AudioManager.Mastervolume = h_slider.value
	AudioManager.BGMVolume = h_slider1.value
	AudioManager.SFXVolume = h_slider2.value

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func MainVisibleToggle():
	title.visible = !title.visible;
	if title.visible:
		optionsT.visible = false;
		credits_t.visible = false;

func _on_play_pressed() -> void:
	AudioManager.kill()
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
	AudioManager.Mastervolume = value;
	AudioManager.updateSound()

func BGMSLIDERCHANGE(value: float) -> void:
	AudioManager.BGMVolume = value;
	AudioManager.updateSound()

func SFXChange(value: float) -> void:
	AudioManager.SFXVolume = value;
	AudioManager.updateSound()

func _on_check_button_toggled(toggled_on: bool) -> void:
	AudioManager.crtT = toggled_on;

func _on_button_pressed() -> void:
	MainVisibleToggle()
