extends CharacterBody2D

@export var tile_map: TileMapLayer
@export var SPEED = 200
const tile_width = 16
var current_path: Array[Vector2i]

var is_my_turn = true

#@onready var enemy = get_tree().get_nodes_in_group("enemy")

func _turn_end():
	is_my_turn = false
	GlobalBusyPoint._turn()

func _moving():
	if current_path.is_empty():
		_turn_end()
		return
	var target_position = tile_map.map_to_local(current_path.front())
	#global_position = global_position.move_toward(target_position, SPEED)
	global_position = target_position
	if global_position == target_position:
		current_path.pop_front()
	_moving()

func _move():
	is_my_turn = true

func _unhandled_input(event):
	if !current_path.is_empty(): return
	if !is_my_turn: return

	#var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	#var direction := Vector2(floor(input_dir.x), floor(input_dir.y)).normalized()
	
	var direction = Vector2()
	
	if Input.is_action_pressed("move_left"):
		_input_move(Vector2(-1,0))
		return
		
	if Input.is_action_pressed("move_right"):
		_input_move(Vector2(1,0))
		return
		
	if Input.is_action_pressed("move_up"):
		_input_move(Vector2(0,-1))
		return
		
	if Input.is_action_pressed("move_down"):
		_input_move(Vector2(0,1))
		return

func _input_move(direction):
	if tile_map.is_point_available(global_position+direction*tile_width):
		current_path = tile_map.astar.get_id_path(
			tile_map.local_to_map(global_position),
			tile_map.local_to_map(global_position+direction*tile_width)
			).slice(1)
		_moving()

	#var click_position = get_global_mouse_position()
	#if event.is_action_pressed("move_to"):
		#if tile_map.is_point_available(click_position):
			#current_path = tile_map.astar.get_id_path(
				#tile_map.local_to_map(global_position),
				#tile_map.local_to_map(click_position)
			#).slice(1)
