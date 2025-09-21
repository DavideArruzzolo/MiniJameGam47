extends Switchable
class_name Lever

@export var tile_map_node: TileMap
@export var cells_to_erase: Array[Vector2i]
@export var tile_map_layer_index: int = 0
@export var allowed_clone_type: String = ""
@export var egg_sprite_texture: Texture2D

var egg_sprite_node: Sprite2D

func _ready():
	egg_sprite_node = Sprite2D.new()
	add_child(egg_sprite_node)
	egg_sprite_node.position = Vector2(0, -90)
	egg_sprite_node.scale = Vector2(3,3)
	update_egg_sprite()
	self.StatusChangedEvent.connect(_on_status_changed)

func update_egg_sprite():
	if egg_sprite_texture:
		egg_sprite_node.texture = egg_sprite_texture
		egg_sprite_node.visible = (allowed_clone_type != "")
	else:
		egg_sprite_node.visible = false

func onInteract():
	if Status: # Already activated, do nothing
		return

	var current_player = PlayerManager.players[PlayerManager.current_player_index]
	var can_interact = false
	if allowed_clone_type == "":
		can_interact = true
	elif current_player.name == allowed_clone_type:
		can_interact = true

	if not can_interact:
		return

	Status = true

func _on_status_changed(_switchable, new_status):
	if new_status == true:
		$AudioStreamPlayer.play()
		$AnimatedSprite2D.play("default", -1, true)
		if tile_map_node and not cells_to_erase.is_empty():
			tile_map_node.set_cells_terrain_connect(tile_map_layer_index, cells_to_erase, 0, -1)

func onBodyEntered(body: Node2D) -> void:
	if body is Player:
		body.interacted_event.connect(onInteract)

func onBodyExited(body: Node2D) -> void:
	if body is Player:
		body.interacted_event.disconnect(onInteract)
