extends Control

@onready var item_icon = $Item/ItemIcon

var dragged_item = {} : set = set_dragged_item

func _process(delta):
	if dragged_item:
		position = get_global_mouse_position()

func set_dragged_item(item):
	dragged_item = item
	if dragged_item:
		item_icon.texture = load("res://Icons/%s" % dragged_item.icon)
	else:
		item_icon.texture = null
