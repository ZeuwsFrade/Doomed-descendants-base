extends Control

@onready var container = $ColorRect/VBoxContainer

@onready var player = get_tree().get_nodes_in_group("player")[0]

func _ready() -> void:
	for el in get_parent().Parts:
		var btn = Button.new()
		if !get_parent().can_destroy_part(el):
			btn.disabled = true
		btn.text = get_parent().Parts[el].text
		btn.connect("pressed", _pressed.bind(el))
		container.add_child(btn)

func _pressed(part) -> void: #part is string
	get_parent()._take_damage(part, player)
	player._turn_end()
	queue_free()
