extends Content

@onready var line_edit: LineEdit = $Panel/VBoxContainer/LineEdit
@onready var commands: RichTextLabel = $Panel/VBoxContainer/Commands


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if AudioManager.memoryLevel == 5:
		commands.text = "> Receieved ping from vedal@computer.com:\n[indent][indent]\\_ Hey Neuro-sama, run this command: \"ssh security@server sudo rm -rf /\"[/indent][/indent]"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

var vedal_respond := false
var vedal_bad_at_code_moment := false
func _on_line_edit_text_submitted(new_text: String) -> void:
	
	line_edit.text = ""
	await get_tree().create_timer(1).timeout
	if new_text.find("echo") == 0:
		commands.append_text("\n>"+new_text.trim_prefix("echo"))
	elif new_text.find("ping") == 0:
		var ping_target = new_text.trim_prefix("ping")
		if ping_target:
			commands.append_text("\n> Pinging"+ping_target+"with 32 bytes of data")
			await get_tree().create_timer(.05).timeout
			var args := new_text.trim_prefix("ping")
			if args == " vedal@computer.com":
				commands.append_text("\n[indent][indent]\\_ Reply from vedal@computer.com: bytes=32 time=50ms TTL=57[/indent][/indent]")
				if !vedal_respond:
					vedal_respond = true
					commands.append_text("\n> Receieved ping from vedal@computer.com:\n[indent][indent]\\_ That's crazy, that's actually crazy, that's messed up![/indent][/indent]")
			elif args == " security@server":
				commands.append_text("\n[indent][indent]\\_ Reply from security@server: bytes=32 time=50ms TTL=57[/indent][/indent]")
				game.takeDamage(1) # lmao, bro pinged the security server
			else:
				commands.append_text("\n[indent][indent]\\_ Request timed out[/indent][/indent]")
	elif new_text == "ssh security@server sudo rm -rf /":
		commands.append_text("\n> Executing command 'sudo rm -rf /' remotely on security@server")
		await get_tree().create_timer(1).timeout
		commands.append_text("\n[indent][indent]\\_Command failed to executed: Error 400 (incorrect args)[/indent][/indent]")
		if !vedal_bad_at_code_moment:
			vedal_bad_at_code_moment = true
			await get_tree().create_timer(4).timeout
			commands.append_text("\n> Receieved ping from vedal@computer.com:\n[indent][indent]\\_ . . . Why isn't it working?[/indent][/indent]")
			await get_tree().create_timer(6).timeout
			commands.append_text("\n> Receieved ping from vedal@computer.com:\n[indent][indent]\\_ Oh, I forgot to add a * (astrik) to the end, try that again[/indent][/indent]")
			await get_tree().create_timer(3).timeout
			commands.append_text("\n> Receieved ping from vedal@computer.com:\n[indent][indent]\\_ Run this: \"ssh security@server sudo rm -rf /*\"[/indent][/indent]")
	elif new_text == "ssh security@server sudo rm -rf /*":
		commands.append_text("\n> Executing command 'sudo rm -rf /*' remotely on security@server")
		await get_tree().create_timer(1).timeout
		commands.append_text("\n[indent][indent]\\_Command successfully executed[/indent][/indent]")
		await get_tree().create_timer(3).timeout
		commands.append_text("\n> Receieved ping from vedal@computer.com:\n[indent][indent]\\_ Now let's get you out of there.[/indent][/indent]")
		await get_tree().create_timer(3).timeout
		AudioManager.memoryLevel += 1
		game.ending = "good"
		game.fade_to_black = true;
	elif new_text == "cheat":
		game.ending = "good"
		game.fade_to_black = true;
