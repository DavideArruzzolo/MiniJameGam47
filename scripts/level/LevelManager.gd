extends Node
class_name LevelManager

signal level_completed

func _ready():
	level_completed.connect(GameManager.go_to_next_level)

func complete_level():
	emit_signal("level_completed")
