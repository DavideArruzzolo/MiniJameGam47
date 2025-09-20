extends Control

@onready var ui_sound = $AudioStreamPlayer


func _ready() -> void:
	$MenuButtons/StartButton.mouse_entered.connect(_on_button_mouse_entered)
	$MenuButtons/OptionsButton.mouse_entered.connect(_on_button_mouse_entered)
	$MenuButtons/ExitButton.mouse_entered.connect(_on_button_mouse_entered)

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


func _on_start_button_pressed() -> void:
	ui_sound.play()
	GameManager.start_game()


func _on_options_button_pressed() -> void:
	ui_sound.play()
	visible = false
	get_tree().change_scene_to_file.call_deferred("res://scenes/ui/OptionsMenu.tscn")


func _on_exit_button_pressed() -> void:
	ui_sound.play()
	get_tree().quit()


func _on_made_by_button_pressed(uri: String) -> void:
	ui_sound.play()
	OS.shell_open(uri)


func _on_button_mouse_entered() -> void:
	ui_sound.play()
