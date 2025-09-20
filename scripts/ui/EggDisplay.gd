extends CanvasLayer

@onready var egg_label: TextureRect = $MarginContainer/VBoxContainer/TextureRect

@export var player_texture: Texture2D
@export var clone_1_texture: Texture2D
@export var clone_2_texture: Texture2D
@export var clone_3_texture: Texture2D

func _ready():
	PlayerManager.egg_changed.connect(_on_egg_changed)
	_on_egg_changed(PlayerManager.current_egg)
	egg_label.texture = player_texture

func _on_egg_changed(_egg_name: String):
	pass

func update_player_info(_player_name: String, _player_color: Color):
	match _player_name:
		"Player":
			egg_label.texture = player_texture
		"Clone 1":
			egg_label.texture = clone_1_texture
		"Clone 2":
			egg_label.texture = clone_2_texture
		"Clone 3":
			egg_label.texture = clone_3_texture
