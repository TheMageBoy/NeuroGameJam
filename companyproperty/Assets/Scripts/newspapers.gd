extends Content

@onready var files: VBoxContainer = $ScrollContainer/Files
const TEXT_FILE = preload("res://Assets/Scenes/Content/text_file.tscn")
# Called when the node enters the scene tree for the first time.
const NEWSPAPER_FILE = preload("res://Assets/Scenes/newspaper_file.tscn")
func _ready() -> void:
	for file in DirAccess.get_files_at("res://Assets/TextFiles/Newspapers/"):
		var file_content := FileAccess.open("res://Assets/TextFiles/Newspapers/"+file, FileAccess.READ).get_as_text()
		var string_array := file_content.split("\n===\n")
		if string_array.size() == 1:
			string_array = file_content.split("\n===\r\n")
		var news_file_inst := NEWSPAPER_FILE.instantiate()
		
		if (str_to_var(string_array[1]) <= AudioManager.memoryLevel):
			var news_title : String = ""
			var news_title_parts := string_array[0].split(" ")
			for part in news_title_parts:
				var cur_part := part
				
				if !randi()%3:
					cur_part = "[i]"+cur_part+"[/i]"
				if !randi()%6:
					cur_part = "[b]"+cur_part+"[/b]"
				if !randi()%9:
					cur_part = "[color=red]"+cur_part+"[/color]"
				elif !randi()%9:
					cur_part = "[color=purple]"+cur_part+"[/color]"
				if !randi()%12:
					cur_part = "[wave]"+cur_part+"[/wave]"
				if !randi()%12:
					cur_part = "[shake]"+cur_part+"[/shake]"
				if !randi()%12:
					cur_part = "[pulse]"+cur_part+"[/pulse]"
				news_title += cur_part+" "
			news_file_inst.get_node("HBoxContainer/FileName").text = " "+news_title+"[font_size=8]\n"+string_array[2].trim_suffix("\n").left(24)+"[/font_size]..."
			print("TEXT: "+var_to_str(news_file_inst.get_node("HBoxContainer/FileName").text))
			files.add_child(news_file_inst)
			
			news_file_inst.pressed.connect(Callable(game, "createWindow").bind(news_file_inst, Vector2(256, 256), false, TEXT_FILE, string_array[2]))

func _on_rich_text_label_meta_clicked(meta: Variant) -> void:
	print(meta)

func _on_tree_exiting() -> void:
	for file in files.get_children():
		if file.window:
			file.window.queue_free()
