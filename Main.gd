extends Node2D


func _ready() -> void:
	visible = false
	get_tree().change_scene_to_file.call_deferred("res://scenes/ui/SplashScreen.tscn")
