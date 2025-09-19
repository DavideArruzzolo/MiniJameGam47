extends CharacterBody2D

var player_scene: PackedScene = preload("res://scenes/player/Player.tscn")

var clone_generation: int = 0
var can_clone: bool = true

signal interacted_event

func init_clone(clone_num: int, position: Vector2) -> void:
	global_position = position
	can_clone = false
	
	if(clone_num >= 1):
		$MovementComponent.max_jumps = 1;
	if(clone_num >= 2):
		$MovementComponent.character_allows_dashing = false;
	if(clone_num >= 3):
		$MovementComponent.max_jumps = 0;

func _physics_process(delta: float) -> void:
	if(Input.is_action_just_pressed("clone") && can_clone):
		clone()
	
	if(Input.is_action_just_pressed("interact")):
		emit_signal("interacted_event")

func clone() -> void:
	clone_generation += 1;
	
	var instance = player_scene.instantiate()
	instance.init_clone(clone_generation, global_position)
	get_parent().add_child(instance)
