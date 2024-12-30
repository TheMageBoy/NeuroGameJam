extends Content

@onready var files: VBoxContainer = $ScrollContainer/Files
const TEXT_FILE = preload("res://Assets/Scenes/Content/text_file.tscn")
# Called when the node enters the scene tree for the first time.
const company_log = preload("res://Assets/Scenes/company_log.tscn")
func _ready() -> void:
	for file in DirAccess.get_files_at("res://Assets/TextFiles/CompanyLogs/"):
		var file_content := FileAccess.open("res://Assets/TextFiles/CompanyLogs/"+file, FileAccess.READ).get_as_text()
		var string_array := file_content.split("\n===\n")
		if string_array.size() == 1:
			string_array = file_content.split("\n===\r\n")
		if (str_to_var(string_array[1]) <= AudioManager.memoryLevel):
			var comp_log_inst := company_log.instantiate()
			comp_log_inst.get_node("HBoxContainer/FileName").text = " [img]res://Assets/Sprites/Icons/paper.png[/img] "+string_array[0]
			comp_log_inst.get_node("HBoxContainer/Corpa").text = string_array[2]
			files.add_child(comp_log_inst)
			comp_log_inst.pressed.connect(Callable(game, "createWindow").bind(comp_log_inst, Vector2(256, 256), false, TEXT_FILE, string_array[3]))

func _on_rich_text_label_meta_clicked(meta: Variant) -> void:
	print(meta)

func _on_tree_exiting() -> void:
	for file in files.get_children():
		if file.window:
			file.window.queue_free()
