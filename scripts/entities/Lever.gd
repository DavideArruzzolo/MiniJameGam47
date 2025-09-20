extends Switchable
class_name Lever

@export var allowed_clone_type: String = ""
@export var egg_sprite_texture: Texture2D

var egg_sprite_node: Sprite2D

func _ready():
	egg_sprite_node = Sprite2D.new()
	add_child(egg_sprite_node)
	egg_sprite_node.position = Vector2(0, -90) # This position might need adjustment in the editor
	egg_sprite_node.scale = Vector2(3,3)
	update_egg_sprite()

func update_egg_sprite():
	if egg_sprite_texture:
		egg_sprite_node.texture = egg_sprite_texture
		egg_sprite_node.visible = (allowed_clone_type != "")
	else:
		egg_sprite_node.visible = false

func onInteract():
	if Status:
		Status = false
		$AnimatedSprite2D.play("default")
		$AudioStreamPlayer.play()
	else:
		Status = true
		$AnimatedSprite2D.play("default", -1, true)
		$AudioStreamPlayer.play()

func onBodyEntered(body: Node2D) -> void:
	if body is Player:
		var can_interact = false
		if allowed_clone_type == "": # No specific clone type required
			can_interact = true
		elif body.name == allowed_clone_type: # Specific clone type required and matches
			can_interact = true

		if can_interact:
			body.interacted_event.connect(onInteract)

func onBodyExited(body: Node2D) -> void:
	if body is Player:
		var can_interact = false
		if allowed_clone_type == "": # No specific clone type required
			can_interact = true
		elif body.name == allowed_clone_type: # Specific clone type required and matches
			can_interact = true

		if can_interact:
			body.interacted_event.disconnect(onInteract)
