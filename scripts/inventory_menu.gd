extends ContainerSlot

func _ready():
	display_item_slot(InventoryAccess.cols, InventoryAccess.rows)
	position = (get_viewport_rect().size - size) / 2
