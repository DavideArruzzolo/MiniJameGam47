extends AudioStreamPlayer

const MIN_VOLUME_DB = -80.0

var volume = 15.0

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	set_volume(volume)
	finished.connect(play)
	if not is_playing():
		play()

func set_volume(slider_value: float):
	volume = slider_value
	if slider_value == 0:
		volume_db = MIN_VOLUME_DB
	else:
		volume_db = linear_to_db(slider_value / 100.0)

	# If the stream was paused (e.g. by the pause menu) and the user is changing volume,
	# unpause it if the volume is now greater than 0.
	if slider_value > 0 and stream_paused:
		stream_paused = false
