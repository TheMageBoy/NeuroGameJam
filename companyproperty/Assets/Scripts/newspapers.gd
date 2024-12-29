extends Content

@onready var files: VBoxContainer = $Files
const TEXT_FILE = preload("res://Assets/Scenes/Content/text_file.tscn")
# Called when the node enters the scene tree for the first time.
const NEWSPAPER_FILE = preload("res://Assets/Scenes/newspaper_file.tscn")
func _ready() -> void:
	for file in DirAccess.get_files_at("res://Assets/TextFiles/Newspapers/"):
		var file_content := FileAccess.open("res://Assets/TextFiles/Newspapers/"+file, FileAccess.READ).get_as_text()
		var string_array := file_content.split("\n===\n")
		var news_file_inst := NEWSPAPER_FILE.instantiate()
		news_file_inst.get_node("HBoxContainer/FileName").text = string_array[0]
		files.add_child(news_file_inst)
		news_file_inst.pressed.connect(Callable(game, "createWindow").bind(news_file_inst, Vector2(256, 256), false, TEXT_FILE, string_array[1]))

func _on_rich_text_label_meta_clicked(meta: Variant) -> void:
	print(meta)

func _on_tree_exiting() -> void:
	for file in files.get_children():
		if file.window:
			file.window.queue_free()
