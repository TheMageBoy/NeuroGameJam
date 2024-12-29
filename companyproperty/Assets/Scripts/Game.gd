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
@onready var penalty_bar: Array[Node] = $Background/Lifebar.get_children()

const UI_WINDOW = preload("res://Assets/Scenes/UI_Window.tscn")

var files := [
	{
		"name": "READ ME",
		"icon": "paper",
		"content": "read_me",
		"size": Vector2i(512, 256),
		"work": false,
		"visible": true
	},
	{
		"name": "homework",
		"icon": "paper",
		"content": "test_content",
		"size": Vector2i(256, 256),
		"work": false,
		"visible": false
	},
	{
		"name": "tweeter",
		"icon": "console",
		"content": "tweeter",
		"size": Vector2i(512, 160),
		"work": true,
		"visible": false
	},
	{
		"name": "reviewer",
		"icon": "console",
		"content": "reviewer",
		"size": Vector2i(576, 160),
		"work": true,
		"visible": false
	},
	{
		"name": "chooser",
		"icon": "console",
		"content": "chooser",
		"size": Vector2i(512, 256),
		"work": true,
		"visible": false
	}
]

var vaild_content_array := []

const FILE = preload("res://Assets/Scenes/File.tscn")
const MONARCH = preload("res://Assets/Sounds/BGM/MONARCH.mp3")
func _ready() -> void:
	for file in DirAccess.get_files_at("res://Assets/Scenes/Content/"):
		vaild_content_array.append(file.erase(file.length()-4, 4))
	
	AudioManager.play_bgm(MONARCH)
	
	for file : Dictionary in files: # this loads the files into the desktop
		var file_inst := FILE.instantiate()
		desktop_files.add_child(file_inst)
		
		file_inst.visible = file["visible"]
		file_inst.name = file["name"]
		file_inst.rtl.text = "[center]"+file["name"]
		file_inst.icon_sprite.texture = load("res://Assets/Sprites/Icons/"+file["icon"]+".png")
		file_inst.content = load("res://Assets/Scenes/Content/"+file["content"]+".tscn")
		file_inst.connect("pressed", Callable(self, "createWindow").bind(file_inst, file["size"], file["work"], file_inst.content))

func createWindow(file : Button, size, is_task : bool, content):
	if file.window == null:
		var new_window = UI_WINDOW.instantiate()
		new_window.name = file.rtl.text
		new_window.size = size
		new_window.work_task = is_task
		new_window.content = content
		window_node.add_child(new_window)
		new_window.progress_bar.show_percentage = is_task
		window_array.append(new_window)
		file.window = new_window
		new_window.file = file
		for task_bar : ProgressBar in task_list.get_children():
			var task_name : String = task_bar.get_node("TaskName").text
			print(new_window.name, " vs ", task_name)
			if new_window.name == task_name:
				print("LINKED")
				new_window.has_lifespan = true
				new_window.task_bar = task_bar
				new_window.progress_bar.max_value = task_bar.max_value
				new_window.progress_bar.value = task_bar.value
				print("VALUES SET")
		return new_window

func deleteWindow(window): #deletes a window after passing itself in
	window.file.window = null
	window_array.erase(window)
	window.queue_free()

func move_to_top(window):
	window_array.erase(window)
	window_array.append(window)

func failedTask(window): # redundant
	print("window closing")
	deleteWindow(window)

func takeDamage(amount):
	lives += -amount
	for index : int in amount:
		penalty_bar[index].frame = 1

## test system, you can probably come up with something better #
func unlock_file():
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
	if eye.visible and checking: # this is the more important part
		check_on_task()
	if !checking:
		check_timer -= delta *2
		if check_timer < 0:
			checking = true
			check_queue()
	forced_timer(delta)
	
	
	# active madatory tasks
	for progress_bar : ProgressBar in task_list.get_children():
		
		if !progress_bar.get_node("CheckBox/Complete").visible and !progress_bar.get_node("CheckBox/Fail").visible:
			progress_bar.value -= delta * 2.0
		
		if progress_bar.value == 0:
			progress_bar.get_node("CheckBox/Fail").visible = true
			progress_bar.get_node("TaskName").text = "[center][color=red]FAILED"
			await task_fail()
			task_bar_free(progress_bar)

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
			takeDamage(1)
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
	forced_task_timer -= delta * 2
	if forced_task_timer <= 0:
		send_forced_task()
		forced_task_timer = 30.0 #probably going to be a randomized amount # you got that right king

@onready var task_list: VBoxContainer = $TaskList
const TASK_PROGRESS_BAR = preload("res://Assets/Scenes/task_progress_bar.tscn")

const NEWTASK = preload("res://Assets/Sounds/SFX/newtask.mp3")
func send_forced_task():
	var task_array : Array[String] = ["reviewer", "tweeter"] # "chooser"
	var task_bar_inst := TASK_PROGRESS_BAR.instantiate()
	task_bar_inst.get_node("TaskName").text = "[center]"+task_array[randi() % task_array.size()]
	task_list.add_child(task_bar_inst)
	task_list.move_child(task_bar_inst, 0)
	AudioManager.play(NEWTASK)
	task_bar_inst.get_node("AnimationPlayer").play_backwards("Squeeze")

func clear_forced_task(window):
	for f_window in forced_task_windows:
		if window == f_window:
			forced_task_windows.erase(window)
			return

func task_bar_free(node):
	await get_tree().create_timer(2).timeout
	var task_bar_ap = node.get_node("AnimationPlayer")
	task_bar_ap.play("Squeeze")
	await task_bar_ap.animation_finished 
	node.queue_free()


#  #  #  #  #  # 
# Tasks finish #
#  #  #  #  #  #

const TASKCOMPLETE = preload("res://Assets/Sounds/SFX/taskcomplete.mp3")
func task_finish():
	rtl.text = "[center][b]- TASK COMPLETE -"
	AudioManager.play(TASKCOMPLETE)
	AP.play("TaskComplete")
	await AP.animation_finished
	return #no point in "return" here, just something I do sometimes when they are waited on completetion sometimes

const BUZZER = preload("res://Assets/Sounds/SFX/buzzer.mp3")
func task_fail():
	rtl.text = "[center][b][color=red]- TASK FAIL -"
	#AudioManager.play(BUZZER)
	AP.play("TaskFail")
	await AP.animation_finished
	AP.play("RESET") # if we don't do this, the eye stays transparent
	takeDamage(1)
	return #no point in "return" here, just something I do sometimes when they are waited on completetion sometimes

# # # # # # # # #
# Memory CG
# # # # # # # # #

var in_memory_cg := false # while in a memory cg, tasks suspend
var memories := []
var memory_cg_ending := false
@onready var cg_rect: TextureRect = $Memory_CG

func start_memory_cg(character):
	in_memory_cg = true;
	# disable every window
	for window in window_array:
		window.suspended = true
	# do something with cg_rect
	cg_rect = cg_rect
	memory_cg_ending = false
	if !memories.has(character):
		memories.append(character)

func end_memory_cg():
	if length(memories) == 5:
		print("GOOD ENDING")
	for window in window_array:
		window.suspended = false
	in_memory_cg = false
	
func _input(event: InputEvent) -> void:
	if event is InputEventKey and in_memory_cg and !memory_cg_ending:
		memory_cg_ending = true
		
	
>>>>>>> Stashed changes
