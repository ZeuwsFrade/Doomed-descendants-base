extends "res://TEsts/characters_base.gd"
var beta_current_path: Array[Vector2i]
var next_pos = Vector2i()
var past_pos = Vector2i()

var range = 1 # можно цикл е
var is_turn = false
var selected = false
@onready var player = get_tree().get_nodes_in_group("player")[0]
@onready var mobs = get_tree().get_nodes_in_group("enemy")

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
<<<<<<< HEAD
func die():
	queue_free()
=======

>>>>>>> origin/master
var a = []

func _move():
	beta_current_path = tile_map.astar.get_id_path(
		tile_map.local_to_map(global_position),
		tile_map.local_to_map(player.global_position)
		).slice(1)
	if beta_current_path.is_empty():
		_turn_end()
		return
	if beta_current_path.size() > range:
		beta_current_path.resize(range)
		next_pos = beta_current_path.back()
	if tile_map.is_point_available(tile_map.map_to_local(beta_current_path.back())):
		current_path = beta_current_path
		_moving()
	else:
		_turn_end()

func _turn_start():
	if global_position.distance_squared_to(player.global_position) <= GlobalBusyPoint.tile_width*GlobalBusyPoint.tile_width:
		_attack()
	else:
		_move()

<<<<<<< HEAD
func _on_mob_zone_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("Attack") and player.aim_selected == false:
		if selected == false:
			add_to_group("selected")
			selected = true
			player.aim_selected = true
		else:
			remove_from_group("selected")
			selected = false
			player.aim_selected = false
=======
>>>>>>> origin/master

	#if beta_current_path.is_empty():
		#a = mobs
		#a.sort_custom(func(a, b): return a.global_position.distance_squared_to(player.global_position) > b.global_position.distance_squared_to(player.global_position))
		#for i in a:
			#if i == self: continue
			#beta_current_path = tile_map.astar.get_id_path(
			#	tile_map.local_to_map(global_position),
			#	tile_map.local_to_map(i.global_position)
			#).slice(1)
			#if !beta_current_path.is_empty():
			#	break
