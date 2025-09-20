extends Node

@export var levels: Array[PackedScene]

@export var main_menu_scene: PackedScene

var current_level_index: int = -1


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.keycode == KEY_R:
		restart_current_level()


func start_game():
	current_level_index = 0
	if levels.size() > 0:
		get_tree().call_deferred("change_scene_to_packed", levels[current_level_index])
	else:
		go_to_main_menu()


func go_to_next_level():
	current_level_index += 1
	if current_level_index < levels.size():
		get_tree().call_deferred("change_scene_to_packed", levels[current_level_index])
	else:
		go_to_main_menu()


func restart_current_level() -> void:
	if current_level_index != -1 and current_level_index < levels.size():
		get_tree().call_deferred("change_scene_to_packed", levels[current_level_index])
	else:
		get_tree().call_deferred("reload_current_scene")


func go_to_main_menu():
	if main_menu_scene:
		current_level_index = -1
		get_tree().call_deferred("change_scene_to_packed", main_menu_scene)
