extends CharacterBody2D
class_name Player

var player_scene: PackedScene = preload("res://scenes/player/Player.tscn")

@onready var texture = $Texture

@onready var audio_jump: AudioStreamPlayer2D = $AudioStreamPlayerJump
@onready var audio_dash: AudioStreamPlayer2D = $AudioStreamPlayerDash
@onready var audio_walk: AudioStreamPlayer2D = $AudioStreamPlayerWalk

var clone_generation: int # No longer initialized here, will be set in init_clone
var can_clone: bool = true

var is_active: bool = false
var is_clone: bool = false

signal interacted_event

var clone_colors = [Color("ff0000ff"), Color("00ff00ff"), Color("000000ff")]  # Red  # Green  # Blue

var clone_1_animations: SpriteFrames = preload("res://asset/resources/clone_1_animations.tres")
var clone_2_animations: SpriteFrames = preload("res://asset/resources/clone_2_animations.tres")
var clone_3_animations: SpriteFrames = preload("res://asset/resources/clone_3_animations.tres")
var player_animations: SpriteFrames = preload("res://asset/resources/player_animations.tres")


func _ready():
	PlayerManager.register_player(self)
	$MovementComponent.dash_started.connect(_on_dash_started)
	if not is_clone:
		texture.sprite_frames = player_animations # Assign player animations
		if texture.sprite_frames.has_animation("idle"): # Ensure a default animation is set
			texture.play("idle")
		$PlayerTrigger.monitoring = false
		$PlayerTrigger.get_node("CollisionShape2D").disabled = true
		# Set collision for original player
		collision_layer = 0
		set_collision_layer_value(2, true) # Original player is on Layer 2
		collision_mask = 0
		set_collision_mask_value(1, true) # Collide with world
		set_collision_mask_value(3, true) # Collide with interactable


func _exit_tree():
	PlayerManager.unregister_player(self)


func activate():
	is_active = true
	$MovementComponent.is_active = true
	if not is_clone: # Only modulate if not a clone
		texture.modulate = Color.WHITE # Visual feedback for active player


func deactivate():
	is_active = false
	$MovementComponent.is_active = false
	if not is_clone: # Only modulate if not a clone
		texture.modulate = Color.GRAY # Visual feedback for inactive player


func init_clone(pos: Vector2, generation: int) -> void:
	is_clone = true
	self.clone_generation = generation # Assign the global generation to this instance
	pos.x -= 50
	global_position = pos
	# can_clone = false # Removed to allow any active player to create the next clone

	# Set clone specific animations
	match generation:
		1:
			texture.sprite_frames = clone_1_animations
			$MovementComponent.max_jumps = 1 # Il clone 1 non può fare il doppio salto
		2:
			texture.sprite_frames = clone_2_animations
			$MovementComponent.max_jumps = 1 # Il clone 2 può fare solo un salto
			$MovementComponent.character_allows_dashing = false # Il clone 2 non può fare il dash
		3:
			texture.sprite_frames = clone_3_animations
			$MovementComponent.max_jumps = 0 # Il clone 3 non può saltare
			$MovementComponent.character_allows_dashing = false # Il clone 3 non può fare il dash

	# --- Applica le restrizioni in base alla generazione ---
	# (These are now handled within the match statement above)

	# --- Impostazione Layer di Collisione ---
	# 1. Pulisce i layer esistenti. Il clone non deve stare sul layer "player".
	collision_layer = 0

	# Ensure a default animation is set after sprite_frames are assigned
	if texture.sprite_frames.has_animation("idle"):
		texture.play("idle")
	else:
		# If no idle animation, try to play the first available animation
		var anim_names = texture.sprite_frames.get_animation_names()
		if anim_names.size() > 0:
			texture.play(anim_names[0])

	# 2. Assegna il clone al suo layer unico.
	#    Assumiamo che i layer per i cloni inizino dal 4 ("clone1").
	#    generazione 1 -> layer 4
	#    generazione 2 -> layer 5
	var clone_layer = generation + 3
	set_collision_layer_value(clone_layer, true)

	# 3. Imposta la mask. Il clone collide con "world" (layer 1) e "interactable" (3),
	#    ma ignora il player (2) e gli altri cloni (4, 5, ...).
	collision_mask = 0
	set_collision_mask_value(1, true)  # Collide con "world"
	set_collision_mask_value(3, true)  # Collide con "interactable"

	# La vecchia logica del trigger non è più necessaria con questo sistema
	# $PlayerTrigger.body_exited.connect(_on_player_exited)


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

	# Automatically switch control to the new clone
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
			texture.play("idle") # Fallback to idle if no jump animation
	else: # is_on_floor()
		if abs(velocity.x) > 10.0:
			if texture.sprite_frames.has_animation("walk"):
				texture.play("walk")
				if not audio_walk.playing:
					audio_walk.play()
			elif texture.sprite_frames.has_animation("idle"):
				texture.play("idle") # Fallback to idle if no walk animation
		else:
			if texture.sprite_frames.has_animation("idle"):
				texture.play("idle")
			if audio_walk.playing:
				audio_walk.stop()

func _on_dash_started():
	audio_dash.play()
