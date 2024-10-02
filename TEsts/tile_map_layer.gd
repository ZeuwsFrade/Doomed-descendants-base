extends TileMapLayer

var astar = AStarGrid2D.new()
var tilemap_size = get_used_rect().end - get_used_rect().position
var map_rect = Rect2i(Vector2i.ZERO, tilemap_size)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	astar.region = map_rect
	astar.cell_size = tile_set.tile_size
	astar.default_compute_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	astar.default_estimate_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar.update()
	
	for i in tilemap_size.x:
		for j in tilemap_size.y:
			var coords = Vector2(i, j)
			var tile_data = get_cell_tile_data(coords)
			if tile_data and tile_data.get_custom_data('Type') == 'Wall':
				astar.set_point_solid(coords)

@onready var objs = get_tree().get_nodes_in_group("turn")

func is_point_available(position):
	var map_position = local_to_map(position)
	
	var _pos = Vector2(position.x, position.y)
	
	for i in objs:
		if i.global_position == _pos:
			return false
	
	if map_rect.has_point(map_position) and not astar.is_point_solid(map_position):
		return true
	else:
		return false
	
	
