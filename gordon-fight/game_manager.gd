extends Node

var score: int = 0
var final_score: int = 0

var background_music_player: AudioStreamPlayer


func start_music() -> void:
	if background_music_player != null:
		if not background_music_player.playing:
			background_music_player.play()
		return

	var music := load("res://bannyboy-sol-e-alegria-sun-and-joy-452450.mp3") as AudioStreamMP3
	if music == null:
		push_error("Could not load the Bannyboy music track.")
		return

	music.loop = true
	background_music_player = AudioStreamPlayer.new()
	background_music_player.name = "BannyboyMusic"
	background_music_player.stream = music
	add_child(background_music_player)
	background_music_player.play()
