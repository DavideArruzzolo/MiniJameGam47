extends Control

@onready var slider = $MenuButtons/HSlider

const MIN_VOLUME_DB = -80.0
const MAX_VOLUME_DB = 0.0


func _ready() -> void:
	$MenuButtons/HSlider.value = 5 # Initial slider value at 5%


func _on_h_slider_value_changed(slider_value: float):
	if slider_value == 0:
		BackgroundMusic.volume_db = MIN_VOLUME_DB
		BackgroundMusic.stream_paused = true
	else:
		BackgroundMusic.volume_db = linear_to_db(slider_value / 100.0)
		BackgroundMusic.stream_paused = false


func _on_back_button_pressed() -> void:
	visible = false
	get_tree().change_scene_to_file.call_deferred("res://scenes/ui/StartMenu.tscn")
