extends Control

@onready var animation_player = $AnimationPlayer

func _ready() -> void:
	animation_player.play("loading")

func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	visible = false
	get_tree().change_scene_to_file.call_deferred("res://scenes/ui/StartMenu.tscn")
