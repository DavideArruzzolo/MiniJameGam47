extends Node
class_name LevelManager

@export var first_level: PackedScene
var currentLevel = null

func _ready() -> void:
	LoadLevel(first_level)

func LoadLevel(newLevel: PackedScene):
	var instance = newLevel.instantiate()
	add_child(instance)
	currentLevel = instance

func ChangeLevel(newLevel: PackedScene):
	remove_child(currentLevel)s
	LoadLevel(newLevel)
