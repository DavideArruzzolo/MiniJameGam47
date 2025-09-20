extends CharacterBody2D
class_name Player

var player_scene: PackedScene = preload("res://scenes/player/Player.tscn")

@onready var texture = $Texture

var clone_generation: int = 0
var can_clone: bool = true

var is_active: bool = false
var is_clone: bool = false

signal interacted_event

var clone_colors = [Color("ff0000ff"), Color("00ff00ff"), Color("000000ff")]  # Red  # Green  # Blue


func _ready():
	PlayerManager.register_player(self)
	if not is_clone:
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
	pos.x -= 50
	global_position = pos
	can_clone = false
	if generation > 0 && generation <= clone_colors.size():
		texture.modulate = clone_colors[generation - 1]

	# --- Applica le restrizioni in base alla generazione ---
	if generation == 1:
		# Il clone 1 non può fare il doppio salto
		$MovementComponent.max_jumps = 1
	elif generation == 2:
		# Il clone 2 non può fare il dash
		$MovementComponent.character_allows_dashing = false
	elif generation == 3:
		# Il clone 3 non può saltare
		$MovementComponent.max_jumps = 0

	# --- Impostazione Layer di Collisione ---
	# 1. Pulisce i layer esistenti. Il clone non deve stare sul layer "player".
	collision_layer = 0

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
	update_animation()


func clone() -> void:
	clone_generation += 1

	var instance = player_scene.instantiate()
	get_parent().add_child(instance)
	instance.init_clone(global_position, clone_generation)

	# Automatically switch control to the new clone
	PlayerManager.set_active_character(instance)


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
