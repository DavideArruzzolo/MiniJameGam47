extends CharacterBody2D
class_name Player

var player_scene: PackedScene = preload("res://scenes/player/Player.tscn")

@onready var texture = $Texture

@onready var audio_jump: AudioStreamPlayer2D = $AudioStreamPlayerJump
@onready var audio_dash: AudioStreamPlayer2D = $AudioStreamPlayerDash
@onready var audio_walk: AudioStreamPlayer2D = $AudioStreamPlayerWalk

var clone_generation: int
var can_clone: bool = true

var is_active: bool = false
var is_clone: bool = false

signal interacted_event

var clone_colors = [Color("ff7a00ff"), Color("ff5ed3ff"), Color("ffffffff")] 

var clone_1_animations: SpriteFrames = preload("res://asset/resources/clone_1_animations.tres")
var clone_2_animations: SpriteFrames = preload("res://asset/resources/clone_2_animations.tres")
var clone_3_animations: SpriteFrames = preload("res://asset/resources/clone_3_animations.tres")
var player_animations: SpriteFrames = preload("res://asset/resources/player_animations.tres")


func _ready():
	PlayerManager.register_player(self)
	$MovementComponent.dash_started.connect(_on_dash_started)
	if not is_clone:
		name = "Player"
		texture.sprite_frames = player_animations
		if texture.sprite_frames.has_animation("idle"):
			texture.play("idle")
		$PlayerTrigger.monitoring = false
		$PlayerTrigger.get_node("CollisionShape2D").disabled = true
		collision_layer = 0
		set_collision_layer_value(2, true)
		collision_mask = 0
		set_collision_mask_value(1, true)
		set_collision_mask_value(3, true)


func _exit_tree():
	PlayerManager.unregister_player(self)


func activate():
	is_active = true
	$MovementComponent.is_active = true
	if not is_clone:
		texture.modulate = Color.WHITE


func deactivate():
	is_active = false
	$MovementComponent.is_active = false
	if not is_clone:
		texture.modulate = Color.GRAY


func init_clone(pos: Vector2, generation: int) -> void:
	is_clone = true
	self.clone_generation = generation
	print(generation)
	name = "clone_" + str(generation)
	pos.x -= 50
	global_position = pos

	match generation:
		1:
			texture.sprite_frames = clone_1_animations
			$MovementComponent.max_jumps = 1
		2:
			texture.sprite_frames = clone_2_animations
			$MovementComponent.max_jumps = 1
			$MovementComponent.character_allows_dashing = false
		3:
			texture.sprite_frames = clone_3_animations
			$MovementComponent.max_jumps = 0
			$MovementComponent.character_allows_dashing = false


	collision_layer = 0

	if texture.sprite_frames.has_animation("idle"):
		texture.play("idle")
	else:
		var anim_names = texture.sprite_frames.get_animation_names()
		if anim_names.size() > 0:
			texture.play(anim_names[0])

	var clone_layer = generation + 3
	set_collision_layer_value(clone_layer, true)

	collision_mask = 0
	set_collision_mask_value(1, true) 
	set_collision_mask_value(3, true) 



func _physics_process(_delta):
	if is_active:
		if Input.is_action_just_pressed("clone") && can_clone && clone_generation < 3:
			clone()

		if Input.is_action_just_pressed("interact"):
			emit_signal("interacted_event")

		if Input.is_action_just_pressed("jump") and $MovementComponent._can_jump():
			audio_jump.play()
	update_animation()


func clone() -> void:
	var next_generation = PlayerManager.get_next_clone_generation()

	var instance = player_scene.instantiate()
	get_parent().add_child(instance)
	instance.init_clone(global_position, next_generation)

	PlayerManager.set_active_character(instance)


func update_animation() -> void:
	if $MovementComponent.is_dashing():
		if texture.sprite_frames.has_animation("dash"):
			texture.play("dash")
		return

	if velocity.x < 0:
		texture.flip_h = true
	elif velocity.x > 0:
		texture.flip_h = false

	if not is_on_floor():
		if texture.sprite_frames.has_animation("jump"):
			texture.play("jump")
		elif texture.sprite_frames.has_animation("idle"):
			texture.play("idle")
	else:
		if abs(velocity.x) > 10.0:
			if texture.sprite_frames.has_animation("walk"):
				texture.play("walk")
				if not audio_walk.playing:
					audio_walk.play()
			elif texture.sprite_frames.has_animation("idle"):
				texture.play("idle")
		else:
			if texture.sprite_frames.has_animation("idle"):
				texture.play("idle")
			if audio_walk.playing:
				audio_walk.stop()

func _on_dash_started():
	audio_dash.play()
