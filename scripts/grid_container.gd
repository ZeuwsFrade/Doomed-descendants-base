extends GridContainer

class_name ContainerSlot

var ItemSlot = load("res://nodes/UI/items_slot.tscn")
var slots

func create_item_slot(cols: int, rows: int):
	var item_slot
	var list_of_slots: Array = []
	columns = cols
	slots = cols * rows
	for index in range(slots):
		if slots == 12:
			if index < 3:
				item_slot = ItemSlot.instantiate()
				add_child(item_slot)
				item_slot.type = "weapon"
				item_slot.Item_type.text = "W"
				list_of_slots.append(item_slot)
			if index <= 4 and index >= 3:
				item_slot = ItemSlot.instantiate()
				add_child(item_slot)
				item_slot.type = "armor"
				item_slot.Item_type.text = "A"
				list_of_slots.append(item_slot)
			if index < 8 and index >= 5:
				item_slot = ItemSlot.instantiate()
				add_child(item_slot)
				item_slot.type = "accessories"
				item_slot.Item_type.text = "K"
				list_of_slots.append(item_slot)
			if index >= 8:
				item_slot = ItemSlot.instantiate()
				add_child(item_slot)
				item_slot.type = "consumables"
				item_slot.Item_type.text = "C"
				list_of_slots.append(item_slot)
		else:
			item_slot = ItemSlot.instantiate()
			add_child(item_slot)
			item_slot.type = "accessories"
			item_slot.Item_type.text = "K"
			list_of_slots.append(item_slot)
	return list_of_slots
	
	
func display_item_slot(list, slots):
	var added: Array = []
	for item in list:
		for place in slots:
			if place.type == item.type and item not in added and place.item_icon.texture == null:
				place.display_item(item)
				added.append(item)
	InventoryAccess.items_changed.connect(_on_Inventory_items_changed)

func display_new_item_slot(item, slots):
	var added: Array = []
	for place in slots:
			if place.type == item.type and item not in added and place.item_icon.texture == null:
				place.display_item(item)
				added.append(item)


func _on_Inventory_items_changed(indexes):
	var item_slot
	for index in indexes:
		if index < slots:
			item_slot = get_child(index)
			item_slot.display_item(InventoryAccess.items[index])
