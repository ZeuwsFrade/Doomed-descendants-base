extends CharecterBase
#@onready var enemy = get_tree().get_nodes_in_group("enemy")
var enemy_sel
var visible_objs = []
var vision_range = 6

var attack_menu = preload("res://nodes/UI/attack_menu.tscn")

@onready var vision = $Vision

func _deploy() -> void:
	vision.scale = Vector2(vision_range*2,vision_range*2)

func _turn_end():
	print()
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

func _turn_start():
	is_my_turn = true

func _input(event):
	if event.is_action_pressed("LMB"):
		if get_tree().get_nodes_in_group("selected").size() > 0:
			enemy_sel = get_tree().get_nodes_in_group("selected")[0]
			if enemy_sel.global_position.distance_squared_to(self.global_position) <= GlobalBusyPoint.tile_width*GlobalBusyPoint.tile_width:
				#enemy_sel._take_damage(10, self)
				var menu = attack_menu.instantiate()
				enemy_sel.add_child(menu)
				#_turn_end()
	if event.is_action_pressed("RMB"):
		_turn_end()
	if !current_path.is_empty(): return
	if !is_my_turn: return

	#var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	#var direction := Vector2(floor(input_dir.x), floor(input_dir.y)).normalized()
	
	#var direction = Vector2()
	
	if event.is_action_pressed("move_left"):
		_move(Vector2(-1,0))
		return
		
	if event.is_action_pressed("move_right"):
		_move(Vector2(1,0))
		return
		
	if event.is_action_pressed("move_up"):
		_move(Vector2(0,-1))
		return
		
	if event.is_action_pressed("move_down"):
		_move(Vector2(0,1))
		return

func _move(direction):
	if tile_map.is_point_available(global_position+direction*GlobalBusyPoint.tile_width):
		current_path = tile_map.astar.get_id_path(
			tile_map.local_to_map(global_position),
			tile_map.local_to_map(global_position+direction*GlobalBusyPoint.tile_width)
			).slice(1)
	_moving()
	#_visible()

func _raycast( pos_end: Vector2, body ):
	var New_Intersection = PhysicsRayQueryParameters2D.create(self.position, pos_end)
	New_Intersection.exclude = [self, body]
	New_Intersection.collision_mask = pow(2, 1-1)
	var Intersection = get_world_2d().direct_space_state.intersect_ray(New_Intersection)
	return Intersection
	
func _on_vision_body_entered(body: Node2D) -> void:
	if body.is_in_group("turn"):
		if !visible_objs.has(body):
				visible_objs.push_back(body)
		if _raycast(body.position, body).is_empty():
			body.visible = true

func _on_vision_body_exited(body: Node2D) -> void:
	if body.is_in_group("turn"):
		if visible_objs.has(body):
			visible_objs.remove_at(visible_objs.find(body))
		body.visible = false

func _visible():
	for i in visible_objs:
		if _raycast(i.position, i).is_empty():
			i.visible = true
		else:
			i.visible = false
