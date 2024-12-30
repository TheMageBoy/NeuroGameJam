extends Content

@onready var files: VBoxContainer = $ScrollContainer/Files
const TEXT_FILE = preload("res://Assets/Scenes/Content/text_file.tscn")
const JOURNAL_FILE = preload("res://Assets/Scenes/journal_file.tscn")
func _ready() -> void:
	for file in DirAccess.get_files_at("res://Assets/TextFiles/Journal/"):
		var file_content := FileAccess.open("res://Assets/TextFiles/Journal/"+file, FileAccess.READ).get_as_text()
		var string_array := file_content.split("\n===\n")
		if string_array.size() == 1:
			string_array = file_content.split("\n===\r\n")
		if (str_to_var(string_array[1]) <= AudioManager.memoryLevel):
			var journal_file_inst := JOURNAL_FILE.instantiate()
			journal_file_inst.get_node("HBoxContainer/FileName").text = " [img]res://Assets/Sprites/Icons/paper.png[/img] "+string_array[0]
			journal_file_inst.get_node("HBoxContainer/Date").text = string_array[2]
			files.add_child(journal_file_inst)
			journal_file_inst.pressed.connect(Callable(game, "createWindow").bind(journal_file_inst, Vector2(256, 256), false, TEXT_FILE, string_array[3]))

func _on_rich_text_label_meta_clicked(meta: Variant) -> void:
	print(meta)

func _on_tree_exiting() -> void:
	for file in files.get_children():
		if file.window:
			file.window.queue_free()
