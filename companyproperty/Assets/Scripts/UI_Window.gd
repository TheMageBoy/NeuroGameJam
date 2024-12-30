extends Node
class_name UI_Window

@onready var game = get_tree().current_scene

var work_task := false
var focus := false
var has_lifespan := false
var lifespan := 0.1 #miliseconds; 0 if no lifespan

var dragging = false
var drag_pos = Vector2()
var offset = Vector2()

var suspended := false

var mouse_over = false;
var last_higlihted = false; # for if input will register to the current window
var data = null # this is passed over to the content

@onready var node: Node = $".."
@onready var panel: Panel = $"."
@onready var progress_bar: ProgressBar = $VBoxContainer/HBoxContainer/ProgressBar
@onready var content_space: Panel = $VBoxContainer/ContentSpace

@export var content : PackedScene
var content_node = null
var file = null
var task_bar = null #this is only set ever when, it is a mandated task

var top = false; #if this is the topmost

func _ready() -> void:
	lifespan = progress_bar.value
	var content_inst : Content = content.instantiate()
	content_inst.content_self = self
	content_inst.data = data
	content_inst.game = game
	content_space.add_child(content_inst)
	content_inst.task_finish.connect(Callable(self, "task_finish")) # We connect the signal "task finish" to the function below, if the signal is called from the "content" node it will trigger the function below
	content_inst.task_fail.connect(Callable(self, "task_fail"))
	content_node = content_inst

func update_progress_bar(value):
	progress_bar.value = value

const TASKCOMPLETE = preload("res://Assets/Sounds/SFX/taskcomplete.mp3")
func task_finish():
	content_node.triggered = true
	has_lifespan = false
	if task_bar:
		task_bar.get_node("CheckBox/Complete").visible = true
	await game.task_finish()
	game.task_bar_free(task_bar)

const BUZZER = preload("res://Assets/Sounds/SFX/buzzer.mp3")
func task_fail():
	content_node.enabled = false
	content_node.triggered = true
	has_lifespan = false
	if task_bar:
		task_bar.get_node("CheckBox/Fail").visible = true
		task_bar.get_node("TaskName").text = "[center][color=red] FAILED"
	await game.task_fail()
	game.task_bar_free(task_bar)



func _input(event: InputEvent):
	if suspended:
		return
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed and !dragging and mouse_within(get_viewport().get_mouse_position()) and focus:
			offset = panel.get_screen_position() - get_viewport().get_mouse_position();
			dragging = true;#Toggle Dragging when clicked
			get_parent().move_child(self, get_parent().get_child_count()-1)
		if event.button_index == MOUSE_BUTTON_LEFT and !event.pressed and dragging:
			dragging = false;

func _process(delta: float):#I hope this is equivalent to update? It probably is :)
	if dragging == true and !suspended:
		drag_pos = get_viewport().get_mouse_position() + offset;#Drag position is set to mouse position
		panel.global_position = drag_pos#Thus, set transform position to drag position

func setPos(pos:Vector2):
	panel.global_position = pos;

func mouse_within(point):
	if suspended:
		return false
	var x = panel.global_position.x
	var y = panel.global_position.y
	var x2 = x + self.size.x
	var y2 = y + self.size.y
	#TODO: make a check if it is the topmost
	return point.x >= x and point.x <= x2 and point.y >= y and point.y <= y2


# ------------------------------------------
# "Window Focus"
# ------------------------------------------

func _on_progress_bar_mouse_entered() -> void:
	focus = true

func _on_progress_bar_mouse_exited() -> void:
	focus = false


# ------------------------------------------
# X Button
# ------------------------------------------

func _x_button_pressed() -> void:
	#autofails if you try to X out of a task window (failed task closes it)
	if suspended:
		return
	if has_lifespan:
		get_tree().current_scene.failedTask(self)
	else:
		get_tree().current_scene.deleteWindow(self)
