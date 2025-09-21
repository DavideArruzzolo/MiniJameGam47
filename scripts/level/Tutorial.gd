extends Node2D

var current_active_camera: Camera2D = null

func _ready():
	PlayerManager.player_switched.connect(_on_player_switched)
	if PlayerManager.current_player_index != -1:
		var initial_player = PlayerManager.players[PlayerManager.current_player_index]
		_setup_player_camera(initial_player)

func _on_player_switched(player_name, player_color):
	var new_active_player = PlayerManager.players[PlayerManager.current_player_index]
	_setup_player_camera(new_active_player)

func _setup_player_camera(player_node):
	if current_active_camera and is_instance_valid(current_active_camera):
		current_active_camera.queue_free()

	var camera = player_node.find_child("Camera2D")
	if not camera:
		camera = Camera2D.new()
		camera.name = "PlayerCamera"
		player_node.add_child(camera)

	current_active_camera = camera
