extends Node


func play(sound : AudioStream) -> AudioStreamPlayer:
	var audio_player := AudioStreamPlayer.new()
	audio_player.bus = "SFX"
	audio_player.stream = sound
	audio_player.autoplay = true
	add_child(audio_player)
	return audio_player

func play_bgm(sound : AudioStream) -> void:
	var audio_player := AudioStreamPlayer.new()
	audio_player.stream = sound
	audio_player.bus = "BGM"
	add_child(audio_player)
	while true:
		audio_player.playing = true
		await audio_player.finished
		await get_tree().create_timer(30).timeout
