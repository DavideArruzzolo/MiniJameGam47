extends Node
class_name LevelManager

var currentLevel = null


func ChangeScene(newLevel: PackedScene):
	remove_child(currentLevel)
	var instance = newLevel.instantiate
	add_child(instance)
	currentLevel = instance
