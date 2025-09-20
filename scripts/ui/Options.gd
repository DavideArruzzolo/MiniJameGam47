extends Control

@onready var slider = $MenuButtons/HSlider
@onready var ui_sound = $AudioStreamPlayer

const MIN_VOLUME_DB = -80.0
const MAX_VOLUME_DB = 0.0


func _ready() -> void:
	$MenuButtons/HSlider.value = 5
	$MenuButtons/TextureButton.mouse_entered.connect(_on_button_mouse_entered)

	var made_by_buttons = [
		$MadeBy/ProfileHolder/human,
		$MadeBy/ProfileHolder/human2,
		$MadeBy/ProfileHolder/human3,
		$MadeBy/ProfileHolder/human5,
		$MadeBy/ProfileHolder/human6
	]

	for button in made_by_buttons:
		button.mouse_entered.connect(_on_button_mouse_entered)
		button.pressed.connect(Callable(self, "_on_made_by_button_pressed").bind(button.uri))


func _on_h_slider_value_changed(slider_value: float):
	ui_sound.play()
	if slider_value == 0:
		BackgroundMusic.volume_db = MIN_VOLUME_DB
		BackgroundMusic.stream_paused = true
	else:
		BackgroundMusic.volume_db = linear_to_db(slider_value / 100.0)
		BackgroundMusic.stream_paused = false


func _on_back_button_pressed() -> void:
	ui_sound.play()
	visible = false
	get_tree().change_scene_to_file.call_deferred("res://scenes/ui/StartMenu.tscn")


func _on_made_by_button_pressed(uri: String) -> void:
	ui_sound.play()
	OS.shell_open(uri)


func _on_button_mouse_entered() -> void:
	ui_sound.play()
