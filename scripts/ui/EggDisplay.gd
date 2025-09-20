extends CanvasLayer

@onready var egg_label: TextureRect = $MarginContainer/VBoxContainer/TextureRect

func _ready():
	PlayerManager.egg_changed.connect(_on_egg_changed)
	_on_egg_changed(PlayerManager.current_egg)

func _on_egg_changed(_egg_name: String):
	pass # No longer handling text for egg_name

func update_player_info(_player_name: String, player_color: Color):
	egg_label.modulate = player_color
