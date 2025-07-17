extends Resource

class_name Item

var name: String
var description: String
var icon: Texture
var id: String #Уникальный идентификатор

static func create_item(name: String, description: String, icon: Texture, id: String) -> Item:
	var item = Item.new()
	item.name = name
	item.description = description
	item.icon = icon
	item.id = id
	return item
