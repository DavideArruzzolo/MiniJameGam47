extends Switchable
class_name ObjButton

@export var tile_map_node: TileMap
@export var cells_to_erase: Array[Vector2i]
@export var tile_map_layer_index: int = 0

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
		if tile_map_node and not cells_to_erase.is_empty():
			call_deferred("erase_cells_with_autotile", cells_to_erase)
	

func onBodyEntered(body):
	if body is Player:
		clonesInAreaCount += 1
		checkSetStatus()

func onBodyExited(body):
	if body is Player:
		clonesInAreaCount -= 1
		checkSetStatus()

func erase_cells_with_autotile(cells: Array[Vector2i]) -> void:
		tile_map_node.set_cells_terrain_connect(tile_map_layer_index, cells, 0, 1)
