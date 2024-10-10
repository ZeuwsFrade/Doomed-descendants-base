extends Node

var global_busy_point = []

const tile_width = 16

var objects
var i = 0

@onready var tilemap = get_tree().get_nodes_in_group("TileMap")[0]

func _turn():
	objects = get_tree().get_nodes_in_group("turn")
	if i < objects.size()-1:
		i=i+1
	else:
		i=0
	tilemap._re_solid( objects[i] )
	objects[i]._turn_start()
	#tilemap._re_solid( objects[i] )
	

func _process(delta: float) -> void:
	pass
