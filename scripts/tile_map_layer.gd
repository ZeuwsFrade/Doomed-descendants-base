extends TileMapLayer

var astar = AStarGrid2D.new()
var tilemap_size = get_used_rect().end - get_used_rect().position
var map_rect = Rect2i(Vector2i.ZERO, tilemap_size)
# Called when the node enters the scene tree for the first time.
@onready var objs = get_tree().get_nodes_in_group("turn")
@onready var player = get_tree().get_nodes_in_group("player")[0]

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
				
		#astar.set_point_solid( local_to_map( el.global_position ), false)

var obj_colliders = []

func _re_solid( obj ):
	if !obj_colliders.is_empty():
		for vec in obj_colliders:
			if vec == null: continue
			astar.set_point_solid( vec, false )
		obj_colliders.clear()
		
	obj_colliders.resize(objs.size())
	
	if obj == null:
		return
	
	for i in range(0, objs.size()):
		if objs[i] == null:
			continue
		obj_colliders[i] = local_to_map(objs[i].global_position)
		if obj != objs[i] and player.global_position != objs[i].global_position:
			if objs[i].global_position.distance_squared_to(obj.global_position) < GlobalBusyPoint.tile_width*GlobalBusyPoint.tile_width * 2 + GlobalBusyPoint.tile_width:
				astar.set_point_solid( obj_colliders[i], true)

func is_point_available(pos):
	objs = get_tree().get_nodes_in_group("turn")
	var map_position = local_to_map(pos)
	
	var _pos = Vector2(pos.x, pos.y)
	
	for i in objs:
		if i.global_position == _pos:
			return false
	
	if map_rect.has_point(map_position) and not astar.is_point_solid(map_position):
		return true
	else:
		return false
	
	
