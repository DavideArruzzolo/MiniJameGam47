extends AudioStreamPlayer

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	if not is_playing():
		play()
	if stream:
		var playback = get_stream_playback()
		if playback and playback.has_method("set_loop"):
			playback.set_loop(true)
