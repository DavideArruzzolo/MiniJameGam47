extends Switchable
class_name ObjButton

@export var tile_map_node: TileMap
@export var cells_to_erase: Array[Vector2i]
@export var tile_map_layer_index: int = 0
@export var allowed_clone_type: String = ""
@export var egg_sprite_texture: Texture2D
@export var displayText : String

var egg_sprite_node: Sprite2D
var bodies_on_button: Array = []
var original_tile_data: Dictionary = {}

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
	if get_node_or_null("Label"):
		$Label.text = displayText

func onBodyEntered(body):
	bodies_on_button.append(body)
	update_button_state()

func onBodyExited(body):
	bodies_on_button.erase(body)
	update_button_state()

func update_button_state():
	var should_be_active = false
	for body in bodies_on_button:
		if allowed_clone_type == "" or body.name == allowed_clone_type:
			should_be_active = true
			break
	
	if Status != should_be_active:
		Status = should_be_active

func _on_status_changed(_switchable, new_status):
	$AudioStreamPlayer.play()
	
	if new_status == true:
		$AnimatedSprite2D.frame = 1
		if tile_map_node and not cells_to_erase.is_empty():
			if original_tile_data.is_empty():
				for cell in cells_to_erase:
					if tile_map_node.get_cell_source_id(tile_map_layer_index, cell) != -1:
						var cell_info = {}
						cell_info["source"] = tile_map_node.get_cell_source_id(tile_map_layer_index, cell)
						cell_info["atlas"] = tile_map_node.get_cell_atlas_coords(tile_map_layer_index, cell)
						cell_info["alt"] = tile_map_node.get_cell_alternative_tile(tile_map_layer_index, cell)
						original_tile_data[cell] = cell_info
			
			tile_map_node.set_cells_terrain_connect(tile_map_layer_index, cells_to_erase, 0, 1)
	else:
		$AnimatedSprite2D.frame = 0
		if tile_map_node and not original_tile_data.is_empty():
			for cell in original_tile_data:
				var tile_info = original_tile_data[cell]
				tile_map_node.set_cell(tile_map_layer_index, cell, tile_info["source"], tile_info["atlas"], tile_info["alt"])
			
			tile_map_node.notify_runtime_tile_data_update(tile_map_layer_index)
			
			original_tile_data.clear()
