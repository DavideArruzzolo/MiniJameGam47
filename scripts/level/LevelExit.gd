extends Node
class_name LevelExit

var levelManager: LevelManager
@export var nextLevel: PackedScene = null

func _ready() -> void:
	levelManager = get_parent().get_parent()

func _on_body_entered(body: Node2D) -> void:
	if(body is Player):
		levelManager.ChangeLevel(nextLevel)
