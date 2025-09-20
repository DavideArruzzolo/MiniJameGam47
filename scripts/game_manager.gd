extends Node

@export var levels: Array[PackedScene]
@export var main_menu_scene: PackedScene
@export var egg_display_scene: PackedScene

var current_level_index: int = -1
var _egg_display_instance: CanvasLayer

func _ready():
	if egg_display_scene:
		_egg_display_instance = egg_display_scene.instantiate()
		add_child(_egg_display_instance)
	
	get_tree().node_added.connect(_on_node_added)
	PlayerManager.player_switched.connect(_egg_display_instance.update_player_info)
	_on_current_scene_changed()

	if PlayerManager.current_player_index != -1:
		var initial_player = PlayerManager.players[PlayerManager.current_player_index]
		var player_name = "Player"
		if initial_player.is_clone:
			player_name = "Clone " + str(initial_player.clone_generation)
		_egg_display_instance.update_player_info(player_name, initial_player.texture.modulate)


func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.keycode == KEY_R:
		restart_current_level()


func start_game():
	PlayerManager.reset_clones_and_counter()
	current_level_index = 0
	if levels.size() > 0:
		get_tree().call_deferred("change_scene_to_packed", levels[current_level_index])
	else:
		go_to_main_menu()


func go_to_next_level():
	PlayerManager.reset_clones_and_counter()
	current_level_index += 1
	if current_level_index < levels.size():
		get_tree().call_deferred("change_scene_to_packed", levels[current_level_index])
	else:
		go_to_main_menu()


func restart_current_level() -> void:
	PlayerManager.reset_clones_and_counter()
	if current_level_index != -1 and current_level_index < levels.size():
		get_tree().call_deferred("change_scene_to_packed", levels[current_level_index])
	else:
		get_tree().call_deferred("reload_current_scene")


func go_to_main_menu():
	PlayerManager.reset_clones_and_counter()
	if main_menu_scene:
		current_level_index = -1
		get_tree().call_deferred("change_scene_to_packed", main_menu_scene)

func _on_current_scene_changed():
	if _egg_display_instance:
		var new_scene = get_tree().current_scene
		if new_scene:
			var scene_path = new_scene.scene_file_path
			if scene_path and scene_path.contains("scenes/level/"):
				_egg_display_instance.visible = true
			else:
				_egg_display_instance.visible = false
		else:
			_egg_display_instance.visible = false

func _on_node_added(node: Node):
	if node == get_tree().current_scene:
		_on_current_scene_changed()
