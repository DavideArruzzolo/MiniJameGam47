extends Control

@onready var slider = $MenuButtons/HSlider

const MIN_VOLUME_DB = -80.0
const MAX_VOLUME_DB = 0.0


func _ready() -> void:
	$MenuButtons/HSlider.value = 100


func _on_h_slider_value_changed(slider_value: float):
	print(slider_value)
	BackgroundMusic.volume_db = remap(slider_value, 0.0, 100.0, MIN_VOLUME_DB, MAX_VOLUME_DB)
	if slider_value == 0:
		BackgroundMusic.stream_paused = true
	else:
		BackgroundMusic.stream_paused = false


func _on_back_button_pressed() -> void:
	visible = false
	get_tree().change_scene_to_file.call_deferred("res://scenes/ui/StartMenu.tscn")
