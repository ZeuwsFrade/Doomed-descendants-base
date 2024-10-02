extends CharacterBody2D

@export var tile_map: TileMapLayer
@export var SPEED = 200
const tile_width = 16
var current_path: Array[Vector2i]
var beta_current_path: Array[Vector2i]
var next_pos = Vector2i()

var range = 2

@onready var player = get_tree().get_nodes_in_group("player")[0]

func _turn_end():
	GlobalBusyPoint._turn()

func  _moving():
	if current_path.is_empty():
		return
	var target_position = tile_map.map_to_local(current_path.front())
	global_position = global_position.move_toward(target_position, SPEED*delta)
	if global_position == target_position:
		current_path.pop_front()
	pass

func _move():
	beta_current_path = tile_map.astar.get_id_path(
		tile_map.local_to_map(global_position),
		tile_map.local_to_map(player.global_position)
		).slice(1)
	if beta_current_path.size() > range:
		beta_current_path.resize(range)
		next_pos = beta_current_path.back()
	if tile_map.is_point_available(tile_map.map_to_local(beta_current_path.back())):
		current_path = beta_current_path
		_moving()
	else:
		_turn_end()
