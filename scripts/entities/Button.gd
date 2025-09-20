extends Switchable
class_name ObjButton

@export var tile_map_node: TileMap
@export var cells_to_erase: Array[Vector2i]
@export var tile_map_layer_index: int = 0
@export var allowed_clone_type: String = ""

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
	if(body.name == allowed_clone_type):
		if tile_map_node and not cells_to_erase.is_empty():
			call_deferred("erase_cells_with_autotile", cells_to_erase)

func onBodyExited(body):
	clonesInAreaCount -= 1
	checkSetStatus()

func erase_cells_with_autotile(cells: Array[Vector2i]) -> void:
	for cell in cells:
		tile_map_node.set_cell(tile_map_layer_index, cell, -1)
