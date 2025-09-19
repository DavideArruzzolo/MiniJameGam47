extends Control


func _on_start_button_pressed() -> void:
	visible = false
	get_tree().change_scene_to_file.call_deferred("res://scenes/level/Level.tscn")


func _on_options_button_pressed() -> void:
	visible = false
	get_tree().change_scene_to_file.call_deferred("res://scenes/ui/OptionsMenu.tscn")


func _on_exit_button_pressed() -> void:
	OS.shell_open("https://www.google.com/")
