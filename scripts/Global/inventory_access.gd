extends Node

signal items_changed(indexes)

var cols: int = 6
var rows: int = 2
var slots: int = cols * rows
var items: Array = []

func _ready():
	for i in range(slots):
		items.append({})
	items[0] = GlobalInventory.get_item_by_key("sword")
	items[1] = GlobalInventory.get_item_by_key("leather_boots")
	items[2] = GlobalInventory.get_item_by_key("leather_jacket")

func set_item(index, item):
	var previos_item = items[index]
	items[index] = item
	items_changed.emit([index])
	return previos_item

func remove_item(index):
	var previos_item = items[index].duplicate()
	items[index].clear()
	items_changed.emit([index])
	return previos_item
