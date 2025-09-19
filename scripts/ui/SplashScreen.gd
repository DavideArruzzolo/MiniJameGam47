extends Control


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	visible = false
	get_tree().change_scene_to_file.call_deferred("res://scenes/ui/Menu.tscn")
