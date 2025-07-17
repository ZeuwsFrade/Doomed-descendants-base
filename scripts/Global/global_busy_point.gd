extends Node

var global_busy_point = []

const tile_width = 64
#enum parts {Head, Legs, Arms, Body}
var objects
var i = 0

var tilemap
var player

func _ready():
	if get_tree().get_node_count_in_group("TileMap")>0 and get_tree().get_node_count_in_group("player")>0:
		tilemap = get_tree().get_nodes_in_group("TileMap")[0]
		player = get_tree().get_nodes_in_group("player")[0]
	else:
		tilemap = null
		player = null

func _turn():
	if tilemap == null or player == null:
		return
	objects = get_tree().get_nodes_in_group("turn")
	
	if i < objects.size()-1:
		i=i+1
	else:
		i=0
		
	tilemap._re_solid( null )
	objects[i]._visible()
	objects[i].remove_from_group("selected")
	tilemap._re_solid( objects[i] )
	objects[i]._turn_start()


#func _process(delta: float) -> void:
#	pass
