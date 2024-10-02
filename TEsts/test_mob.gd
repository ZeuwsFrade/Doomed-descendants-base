extends CharacterBody2D

@export var tile_map: TileMapLayer
@export var SPEED = 200
const tile_width = 16
var current_path: Array[Vector2i]

func  _physics_process(delta):
	if global_position not in GlobalBusyPoint.global_busy_point:
		GlobalBusyPoint.global_busy_point.append(global_position)
	if current_path.is_empty():
		return
	var target_position = tile_map.map_to_local(current_path.front())
	global_position = global_position.move_toward(target_position, SPEED*delta)
	if global_position == target_position:
		current_path.pop_front()
		GlobalBusyPoint.global_busy_point.clear()
	move_and_slide()
	pass

func _unhandled_input(_event):
	if global_position.x - floor(global_position.x) == 0 and global_position.y - floor(global_position.y) == 0:
		var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
		var direction := Vector2(floor(input_dir.x), floor(input_dir.y)).normalized()
		print("Mob:", global_position)
		if direction:
			if tile_map.is_point_available(global_position+direction*tile_width) and velocity == Vector2(0,0):
				print(velocity)
				current_path = tile_map.astar.get_id_path(
					tile_map.local_to_map(global_position),
					tile_map.local_to_map(global_position+direction*tile_width)
					).slice(1)
