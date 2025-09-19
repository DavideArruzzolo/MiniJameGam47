extends CharacterBody2D

var player_scene: PackedScene = preload("res://scenes/player/Player.tscn")

@onready var texture = $Texture

var clone_generation: int = 0

signal interacted_event

func init(clone_num: int, position: Vector2) -> void:
	clone_generation = clone_num
	global_position = position
	
	if(clone_generation >= 1):
		$MovementComponent.max_jumps = 1;
	if(clone_generation >= 2):
		$MovementComponent.character_allows_dashing = false;
	if(clone_generation >= 3):
		$MovementComponent.max_jumps = 0;

func _physics_process(delta: float) -> void:
	if(Input.is_action_just_pressed("clone") && clone_generation == 0):
		clone()
	
	if(Input.is_action_just_pressed("interact")):
		emit_signal("interacted_event")
	update_animation()

func clone() -> void:
	var instance = player_scene.instantiate()
	instance.init(clone_generation + 1, global_position)
	get_parent().add_child(instance)

func update_animation() -> void:

	if $MovementComponent.is_dashing():
		texture.play("dash")
		return


	if velocity.x < 0:
		texture.flip_h = true
	elif velocity.x > 0:
		texture.flip_h = false


	if not is_on_floor():
		texture.play("jump")
	else:
	
		if abs(velocity.x) > 10.0:
			texture.play("walk")
		else:
			texture.play("idle")
