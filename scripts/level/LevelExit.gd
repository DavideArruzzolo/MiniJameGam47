extends Node
class_name LevelExit

@export var levelManager : LevelManager
@export var nextLevel : PackedScene = null
	
func onAreaEntered(player):
	levelManager.ChangeScene(nextLevel)
