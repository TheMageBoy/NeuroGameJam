extends Content

@onready var line_edit: LineEdit = $Panel/VBoxContainer/LineEdit
@onready var commands: RichTextLabel = $Panel/VBoxContainer/Commands


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_line_edit_text_submitted(new_text: String) -> void:
	line_edit.text = ""
	if new_text == "ssh security@server sudo rm -rf /*":
		commands.append_text("> Executing command 'sudo rm -rf /*' remotely on security@server")
		await get_tree().create_timer(1).timeout
		commands.append_text("[indent][indent]\\_Comannd successfully executed[/indent][/indent]")
