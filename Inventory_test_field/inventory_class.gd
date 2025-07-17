extends Node

class_name Inventory

var items: Dictionary = {}

func add_item(item: Item) -> void:
	items[item.id] = { "item": item}

func remove_item(item_id: String) -> void:
	if item_id in items:
		items.erase(item_id)

func get_items() -> Dictionary:
	return items
