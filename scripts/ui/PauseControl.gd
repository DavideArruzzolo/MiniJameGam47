extends Control

var paused: bool = false

func _ready() -> void:
	$MainMenu.visible = false

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ESCAPE:
			set_pause(!paused)

func set_pause(value: bool) -> void:
	$MainMenu.visible = value
	$OptionsMenu.visible = false
	get_tree().paused = value
	paused = value
