extends Node


func play(sound : AudioStream):
	var audio_player := AudioStreamPlayer.new()
	audio_player.stream = sound
	audio_player.autoplay = true
	add_child(audio_player)
	await audio_player.finished
	return
