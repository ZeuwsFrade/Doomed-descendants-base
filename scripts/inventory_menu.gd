extends ContainerSlot

func _ready():
	var slots = create_item_slot(InventoryAccess.cols, InventoryAccess.rows)
	display_item_slot(InventoryAccess.items, slots)
	position = (get_viewport_rect().size - size) / 2
