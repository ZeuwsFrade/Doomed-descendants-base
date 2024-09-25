extends Node2D

@export var TileMapLay: TileMapLayer
@onready var astar
func _init_astar(tile_map: TileMapLayer):
	astar = AStar2D.new()
	var cells = tile_map.get_used_cells()
	cells.sort()
	var adjustment = tile_map.cell_size()/2
	
	for i in range(cells.size()):
		var cell = cells[i]
		astar.add_point(i,tile_map.map_to_world(cell) + adjustment)
		
		var neighbours = [
			Vector2(cell.x, cell.y - 1),
			Vector2(cell.x - 1, cell.y),
		]
		for neighbour in neighbours:
			astar.connect_points(i, astar.get_closest_point(tile_map.map_to_world(neighbour)+ adjustment))
