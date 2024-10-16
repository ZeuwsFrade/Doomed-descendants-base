extends "res://scripts/characters_base.gd"
var beta_current_path: Array[Vector2i]
var next_pos = Vector2i()
var past_pos = Vector2i()

var range = 1 # можно цикл е
var is_turn = false

var vision_range = 6 #через метадату сделать размер vision

var triggered = false

@onready var player = get_tree().get_nodes_in_group("player")[0]
@onready var mobs = get_tree().get_nodes_in_group("enemy")

func _deploy() -> void:
	visible = false
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
	if !triggered: 
		_turn_end() 
		return
	if global_position.distance_squared_to(player.global_position) <= GlobalBusyPoint.tile_width*GlobalBusyPoint.tile_width:
		_attack()
	else:
		_move()

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("LMB"):
		if self.is_in_group("selected"):
			remove_from_group("selected")
			print(self.name, " is deselected")
		else:
			add_to_group("selected")
			print(self.name, " is selected")

func _raycast( pos_end: Vector2 ):
	var New_Intersection = PhysicsRayQueryParameters2D.create(self.position, pos_end)
	New_Intersection.exclude = [self, player]
	New_Intersection.collision_mask = pow(2, 1-1)
	var Intersection = get_world_2d().direct_space_state.intersect_ray(New_Intersection)
	return Intersection

const stalking_base = 10
var stalking = stalking_base

func _trigger( is_triggered: bool):
	if !is_triggered and triggered:
		if stalking > 0:
			stalking = stalking - 1
		else:
			stalking = stalking_base
			triggered = is_triggered
	else:
		stalking = stalking_base
		triggered = is_triggered

func _visible():
	if global_position.distance_squared_to(player.global_position) < pow(GlobalBusyPoint.tile_width, 2) * pow(vision_range, 2):
		if _raycast(player.position).is_empty():
			_trigger(true)
		else:
			_trigger(false)
	else:
		_trigger(false)
