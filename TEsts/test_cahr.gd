extends CharacterBody2D

@export var tile_map: TileMapLayer
@export var SPEED = 200
const tile_width = 16
var current_path: Array[Vector2i]

func  _physics_process(delta):
	if current_path.is_empty():
		return
	var target_position = tile_map.map_to_local(current_path.front())
	global_position = global_position.move_toward(target_position, SPEED*delta)
	if global_position == target_position:
		current_path.pop_front()
	pass

func _unhandled_input(event):
	var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction := Vector2(floor(input_dir.x), floor(input_dir.y)).normalized()
	if direction:
		#$"../Sprite2D".position = global_position + direction
		if tile_map.is_point_available(global_position+direction*tile_width):
			current_path = tile_map.astar.get_id_path(
				tile_map.local_to_map(global_position),
				tile_map.local_to_map(global_position+direction*tile_width)
				).slice(1)
	#var click_position = get_global_mouse_position()
	#if event.is_action_pressed("move_to"):
		#if tile_map.is_point_available(click_position):
			#current_path = tile_map.astar.get_id_path(
				#tile_map.local_to_map(global_position),
				#tile_map.local_to_map(click_position)
			#).slice(1)
