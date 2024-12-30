extends Node

var crtT : bool
var volume : float
var memoryLevel : int

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

func kill():
	for audio_player : AudioStreamPlayer in get_children():
		audio_player.stop()

func pause():
	for audio_player : AudioStreamPlayer in get_children():
		audio_player.stream_paused = true

func unpause():
	for audio_player : AudioStreamPlayer in get_children():
		audio_player.stream_paused = false


func getCRT() -> bool:
	return crtT;
