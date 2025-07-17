extends Control

var item: Item = null

func set_item(new_item: Item) -> void:
	item = new_item
	if item:
		$icon.texture = item.icon
		$item_name.text = item.name
	else:
		$icon.texture = null
		$item_name.text = ""
