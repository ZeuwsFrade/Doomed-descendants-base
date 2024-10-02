extends "res://TEsts/characters_base.gd"
var beta_current_path: Array[Vector2i]
var next_pos = Vector2i()

var range = 1 # можно цикл е
var is_turn = false

@onready var player = get_tree().get_nodes_in_group("player")[0]

func _deploy() -> void:
	health = 100
	damage = 10

func _turn_end():
	GlobalBusyPoint._turn()

func  _moving():
	if current_path.is_empty():
		_turn_end()
		return
	var target_position = tile_map.map_to_local(current_path.front())
	global_position = global_position.move_toward(target_position, SPEED)
	if global_position == target_position:
		current_path.pop_front()
	_moving()

func _attack():
	player._take_damage( damage, self )
	_turn_end()

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

func _turn_start():
	if global_position.distance_squared_to(player.global_position) <= 256:
		_attack()
	else:
		_move()
