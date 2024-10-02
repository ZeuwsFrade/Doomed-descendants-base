extends Node

var global_busy_point = []

var objects
var i = 0

func _turn():
	objects = get_tree().get_nodes_in_group("turn")
	print(i)
	if i < objects.size()-1:
		i=i+1
	else:
		i=0
	objects[i]._move()

func _process(delta: float) -> void:
	pass
