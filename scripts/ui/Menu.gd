extends Control


func _on_start_button_pressed() -> void:
	visible = false
	get_tree().change_scene_to_file.call_deferred("res://scenes/main_world.tscn")


func _on_options_button_pressed() -> void:
	visible = false
	get_tree().change_scene_to_file.call_deferred("res://scenes/ui/OptionsMenu.tscn")


func _on_exit_button_pressed() -> void:
	get_tree().quit()
