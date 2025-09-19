class_name MovementComponent extends Node

@onready var character: CharacterBody2D = get_parent()

var is_active: bool = false

signal state_changed(new_state: String)

enum State { IDLE, WALK, JUMP, DASH }

@export_group("Speed and Movement")
@export var speed: float = 600.0
@export var acceleration: float = 0.25
@export var friction: float = 0.1
@export var gravity: float = 980.0
@export var jump_velocity: float = -800.0
@export var max_jumps: int = 2

@export_group("Dash")
@export var dash_speed: float = 1200.0
@export var dash_duration: float = 0.2
@export var dash_cooldown: float = 1.0

@export_group("Timers and Buffers")
@export var coyote_time: float = 0.1
@export var input_buffer_time: float = 0.2

var current_state: State = State.IDLE:
	set(new_state):
		if current_state != new_state:
			current_state = new_state
			var state_name = State.find_key(new_state)
			emit_signal("state_changed", state_name)

var direction: Vector2 = Vector2.ZERO
var coyote_timer: Timer = Timer.new()
var input_buffer_timer: Timer = Timer.new()
var dash_timer: Timer = Timer.new()
var dash_cooldown_timer: Timer = Timer.new()
var has_dashed_in_air: bool = false
var jumps_made: int = 0
var facing_direction: float = 1.0

var character_allows_dashing = true


func _ready() -> void:
	if not character is CharacterBody2D:
		push_error("MovementComponent must be a child of a CharacterBody2D.")
		return
	_setup_timers()


func _physics_process(delta: float) -> void:
	if not character:
		return

	process_input()

	if not character.is_on_floor():
		character.velocity.y += gravity * delta

	match current_state:
		State.IDLE:
			_state_idle()
		State.WALK:
			_state_walk()
		State.JUMP:
			_state_jump()
		State.DASH:
			pass

	character.move_and_slide()

	if character.is_on_floor():
		coyote_timer.start()
		has_dashed_in_air = false
		jumps_made = 0
		if current_state == State.JUMP:
			current_state = State.IDLE


func _state_idle() -> void:
	if is_active and Input.is_action_just_pressed("dash") and _can_dash():
		_perform_dash()
		return
	if direction.x != 0:
		current_state = State.WALK
		return
	character.velocity.x = lerp(character.velocity.x, 0.0, friction)


func _state_walk() -> void:
	if is_active and Input.is_action_just_pressed("dash") and _can_dash():
		_perform_dash()
		return
	if direction.x == 0:
		current_state = State.IDLE
		return
	character.velocity.x = lerp(character.velocity.x, direction.x * speed, acceleration)


func _state_jump() -> void:
	character.velocity.x = lerp(character.velocity.x, direction.x * speed, acceleration)
	if is_active and Input.is_action_just_pressed("dash") and _can_dash():
		_perform_dash()
		return


func _get_input_direction() -> void:
	direction.x = Input.get_axis("move_left", "move_right")
	if direction.x != 0:
		facing_direction = sign(direction.x)


func _perform_jump() -> void:
	character.velocity.y = jump_velocity
	current_state = State.JUMP
	jumps_made += 1

	if jumps_made == 1:
		coyote_timer.stop()
	input_buffer_timer.stop()


func _perform_dash() -> void:
	current_state = State.DASH
	dash_timer.start()

	var dash_direction = sign(direction.x)
	if dash_direction == 0:
		dash_direction = facing_direction

	character.velocity = Vector2(dash_direction * dash_speed, 0)

	if not character.is_on_floor():
		has_dashed_in_air = true
	else:
		dash_cooldown_timer.start()


func _setup_timers() -> void:
	coyote_timer.wait_time = coyote_time
	coyote_timer.one_shot = true
	add_child(coyote_timer)

	input_buffer_timer.wait_time = input_buffer_time
	input_buffer_timer.one_shot = true
	add_child(input_buffer_timer)

	dash_timer.wait_time = dash_duration
	dash_timer.one_shot = true
	dash_timer.connect("timeout", _on_dash_timer_timeout)
	add_child(dash_timer)

	dash_cooldown_timer.wait_time = dash_cooldown
	dash_cooldown_timer.one_shot = true
	add_child(dash_cooldown_timer)


func _on_dash_timer_timeout() -> void:
	current_state = State.IDLE


func _can_dash() -> bool:
	if !character_allows_dashing:
		return false

	var can_air_dash = not character.is_on_floor() and not has_dashed_in_air
	if can_air_dash:
		return true

	var can_ground_dash = character.is_on_floor() and dash_cooldown_timer.is_stopped()
	if can_ground_dash:
		return true
	return false


func process_input() -> void:
	if not is_active:
		direction.x = 0
		input_buffer_timer.stop()
		return

	if current_state == State.DASH:
		direction.x = 0
		return

	_get_input_direction()

	if Input.is_action_just_pressed("jump"):
		input_buffer_timer.start()

	if not input_buffer_timer.is_stopped() and _can_jump():
		_perform_jump()


func _can_jump() -> bool:
	return (
		(not coyote_timer.is_stopped() and max_jumps > 0)
		or (jumps_made > 0 and jumps_made < max_jumps)
	)


func is_dashing() -> bool:
	return current_state == State.DASH
