extends Control


func _on_button_pressed() -> void:
	visible = false
	get_tree().change_scene_to_file.call_deferred("res://scenes/level/Level.tscn")
