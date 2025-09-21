extends Switchable
class_name ObjButton

@export var tile_map_node: TileMap
@export var cells_to_erase: Array[Vector2i]
@export var tile_map_layer_index: int = 0
@export var allowed_clone_type: String = ""
@export var egg_sprite_texture: Texture2D
@export var displayText : String

var egg_sprite_node: Sprite2D

func _ready():
	egg_sprite_node = Sprite2D.new()
	add_child(egg_sprite_node)
	egg_sprite_node.position = Vector2(0, -90)
	egg_sprite_node.scale = Vector2(3,3)
	update_egg_sprite()

func update_egg_sprite():
	if egg_sprite_texture:
		egg_sprite_node.texture = egg_sprite_texture
		egg_sprite_node.visible = (allowed_clone_type != "")
	else:
		egg_sprite_node.visible = false
	$Label.text = displayText

var clonesInAreaCount = 0

func checkSetStatus():
	if Status and clonesInAreaCount == 0:
		Status = false
		$AnimatedSprite2D.frame = 0
		$AudioStreamPlayer.play()
	elif not Status and clonesInAreaCount > 0:
		Status = true
		$AnimatedSprite2D.frame = 1
		$AudioStreamPlayer.play()

func onBodyEntered(body):
	clonesInAreaCount += 1
	checkSetStatus()

	var can_erase = false
	if allowed_clone_type == "":
		can_erase = true
	elif body.name == allowed_clone_type:
		can_erase = true
		
	if can_erase:
		if tile_map_node and not cells_to_erase.is_empty():
			call_deferred("erase_cells_with_autotile", cells_to_erase)

func onBodyExited(_body):
	clonesInAreaCount -= 1
	checkSetStatus()

func erase_cells_with_autotile(cells: Array[Vector2i]) -> void:
	tile_map_node.set_cells_terrain_connect(tile_map_layer_index, cells, 0, 1)
