extends Area2D
class_name LevelExit

signal complete_level

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	pass
	if body is Player and not body.is_clone:
		emit_signal("complete_level")
