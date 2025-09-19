extends Node

func _input(event: InputEvent) -> void:
    if event is InputEventKey and event.pressed and event.keycode == KEY_R:
        restart_current_level()

func restart_current_level() -> void:
    var current_scene_path = get_tree().current_scene.scene_file_path
    get_tree().change_scene_to_file(current_scene_path)