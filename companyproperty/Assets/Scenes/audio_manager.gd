extends Node

var crtT : bool
var Mastervolume : float
var BGMVolume : float
var SFXVolume : float
var memoryLevel := 1

func play(sound : AudioStream) -> AudioStreamPlayer:
	var audio_player := AudioStreamPlayer.new()
	audio_player.bus = "SFX"
	audio_player.stream = sound
	audio_player.autoplay = true
	audio_player.finished.connect(Callable(audio_player, "queue_free"))
	add_child(audio_player)
	return audio_player

func play_bgm(sound : AudioStream) -> void:
	while true:
		var audio_player := AudioStreamPlayer.new()
		audio_player.stream = sound
		audio_player.bus = "BGM"
		add_child(audio_player)
		audio_player.playing = true
		await audio_player.finished
		audio_player.queue_free()
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

func updateSound():
	#print(lerpf(-40,0,Mastervolume/100))
	AudioServer.set_bus_volume_db(0,lerpf(-40,0,Mastervolume/100))
	AudioServer.set_bus_volume_db(1,lerpf(-40,0,BGMVolume/100))
	AudioServer.set_bus_volume_db(2,lerpf(-40,0,SFXVolume/100))
	


func getCRT() -> bool:
	return crtT;
