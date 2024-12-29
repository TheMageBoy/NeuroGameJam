extends Node

var window_array = []
var quota = 10000
var rate = 10 # -quota per second

var lives := 5

@onready var window_node: Control = $WindowNode
@onready var desktop_files: GridContainer = $Background/DesktopFiles
@onready var AP: AnimationPlayer = $RichTextLabel/AnimationPlayer
@onready var rtl: RichTextLabel = $RichTextLabel
@onready var eye: Sprite2D = $Eye
@onready var eye_AP: AnimationPlayer = $Eye/AnimationPlayer

@export var progress_bar: Node = null
@onready var penalty_bar: Array[Sprite2D] = [$Background/Lifebar/A, $Background/Lifebar/B, $Background/Lifebar/C, $Background/Lifebar/D, $Background/Lifebar/E]

const UI_WINDOW = preload("res://Assets/Scenes/UI_Window.tscn")

var files := [
	{
		"name": "READ ME",
		"icon": "paper",
		"content": "read_me",
		"size": Vector2i(512, 256),
		"life_span": false,
		"visible": true
	},
	{
		"name": "homework",
		"icon": "paper",
		"content": "test_content",
		"size": Vector2i(256, 256),
		"life_span": false,
		"visible": false
	},
	{
		"name": "tweeter",
		"icon": "console",
		"content": "tweeter",
		"size": Vector2i(512, 160),
		"life_span": true,
		"visible": false
	},
	{
		"name": "reviewer",
		"icon": "console",
		"content": "reviewer",
		"size": Vector2i(576, 160),
		"life_span": true,
		"visible": false
	}
]

const FILE = preload("res://Assets/Scenes/File.tscn")

const MONARCH = preload("res://Assets/Sounds/BGM/MONARCH.mp3")
func _ready() -> void:
	AudioManager.play_bgm(MONARCH)
	
	for file : Dictionary in files: # this loads the files into the desktop
		var file_inst := FILE.instantiate()
		desktop_files.add_child(file_inst)
		
		file_inst.visible = file["visible"]
		file_inst.name = file["name"]
		file_inst.rts.text = "[center]"+file["name"]
		file_inst.icon_sprite.texture = load("res://Assets/Sprites/Icons/"+file["icon"]+".png")
		file_inst.content = load("res://Assets/Scenes/Content/"+file["content"]+".tscn")
		file_inst.connect("pressed", Callable(self, "createWindow").bind(file["size"], file["life_span"], file_inst.content))

func createWindow(size, is_task : bool, content):
	var new_window = UI_WINDOW.instantiate()
	new_window.size = size
	new_window.has_lifespan = is_task
	new_window.work_task = is_task
	new_window.content = content
	new_window.setup_window(3000)
	window_node.add_child(new_window)
	new_window.progress_bar.show_percentage = is_task
	window_array.append(new_window)
	return new_window

func deleteWindow(window): #deletes a window after passing itself in
	
	window_array.erase(window)
	window.queue_free()
	
func move_to_top(window):
	window_array.erase(window)
	window_array.append(window)

func failedTask(window):
	print("RAN OUT OF TIME ON TASK")
	takeDamage(1)
	deleteWindow(window)

func takeDamage(amount):
	var current = lives
	lives += -amount
	for i in range(amount):
		var j = current-1-i
		if j >= 0:
			penalty_bar[j].visible = false

## test system, you can probably come up with something better
func unlock_file():
	can_force_task = true
	for file in desktop_files.get_children():
		if !file.visible:
			file.visible = true
			break

# # # # # # # # #
#
# Staying on task
#
# # # # # # # # #

var check_timer := 10.0
var checking := true # this is just for when the sound is playing
func _process(delta: float) -> void:
	if eye.visible: # this is the more important part
		check_on_task()
	if !checking:
		check_timer -= delta *2
		if check_timer < 0:
			checking = true
			check_queue()
	forced_timer(delta)
	

const STEPS = preload("res://Assets/Sounds/SFX/steps.wav") # SFX
func check_queue():
	var stream := AudioManager.play(STEPS) # Audiomanager
	await get_tree().create_timer(5).timeout
	eye.visible = true # refer to the when I said that was the important part
	eye_AP.play_backwards("Fade")
	await stream.finished
	if checking:
		check_timer = randf_range(30, 120)
		checking = false
		eye_AP.play("Fade")
		await eye_AP.animation_finished
		eye.visible = false
	

func check_on_task(): # so we can see if neuro is off task
	for window in window_node.get_children():
		if !window.work_task:
			print("LIFE LOST, AHHHHH") #There is no consequence atm
			checking = false
			check_timer = randf_range(30, 120)
			eye_AP.play("Fade")
			await eye_AP.animation_finished
			eye.visible = false
			break

# # # # # # # # #
# Forced Task
# # # # # # # # #

var forced_task_timer := 2.00 # TODO change this / timer before a forced task is sent
var can_force_task := false # Cannot force tasks until readme has been read
var forced_task_windows := []

func forced_timer(delta):
	if !can_force_task:
		return
	forced_task_timer -= delta *2
	if forced_task_timer <= 0:
		send_forced_task()
		forced_task_timer += 10.00 #probably going to be a randomized amount

func send_forced_task():
	var forced_task_list := [2,3]
	var task = forced_task_list[randi() % forced_task_list.size()]
	var file = files[task]
	var game = file["content"]
	var cont = load("res://Assets/Scenes/Content/"+game+".tscn")
	var forced_task_window = createWindow(file["size"], true, cont)
	forced_task_windows.append(forced_task_window)

func clear_forced_task(window):
	for f_window in forced_task_windows:
		if window == f_window:
			forced_task_windows.erase(window)
			return
