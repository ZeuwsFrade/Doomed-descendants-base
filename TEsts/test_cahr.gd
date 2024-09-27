extends CharacterBody2D

@export var tile_map: TileMapLayer
@export var SPEED = 2
const tile_width = 16
var current_path: Array[Vector2i]

var acces = {}
@onready var enemy = get_tree().get_nodes_in_group("enemy")

func _moving():
	if current_path.is_empty():
		return
	var target_position = tile_map.map_to_local(current_path.front())
	global_position = global_position.move_toward(target_position, SPEED)
	if global_position == target_position:
		current_path.pop_front()
	_moving()

func _unhandled_input(event):
	if !current_path.is_empty(): return
	for i in acces:
		if !acces.is_empty() and acces[i] != true:
			return
	var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction := Vector2(floor(input_dir.x), floor(input_dir.y)).normalized()
	if direction:
		if tile_map.is_point_available(global_position+direction*tile_width):
			current_path = tile_map.astar.get_id_path(
				tile_map.local_to_map(global_position),
				tile_map.local_to_map(global_position+direction*tile_width)
				).slice(1)
		acces.clear()
		_moving()
		get_tree().call_group("enemy", "_move")
	
	
	
	#var click_position = get_global_mouse_position()
	#if event.is_action_pressed("move_to"):
		#if tile_map.is_point_available(click_position):
			#current_path = tile_map.astar.get_id_path(
				#tile_map.local_to_map(global_position),
				#tile_map.local_to_map(click_position)
			#).slice(1)
