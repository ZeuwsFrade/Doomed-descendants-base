extends Control

@onready var btn_arms = $VBoxContainer/Arms
@onready var btn_legs = $VBoxContainer/Legs
@onready var btn_head = $VBoxContainer/Head
@onready var btn_random = $VBoxContainer/Random
@onready var btn_body = $VBoxContainer/Body

@onready var player = get_tree().get_nodes_in_group("player")[0]

func _ready() -> void:
	btn_body.disabled = true
	if !get_parent().Parts.Head:
		btn_head.disabled = true
		btn_body.disabled = false
	if !get_parent().Parts.Arms:
		btn_arms.disabled = true
		btn_body.disabled = false
	if !get_parent().Parts.Legs:
		btn_legs.disabled = true
		btn_body.disabled = false
	if !get_parent().Parts.Body:
		btn_body.disabled = true

func _on_arms_pressed() -> void:
	get_parent()._take_damage(1, player)
	player._turn_end()
	queue_free()

func _on_legs_pressed() -> void:
	get_parent()._take_damage(2, player)
	player._turn_end()
	queue_free()

func _on_head_pressed() -> void:
	get_parent()._take_damage(0, player)
	player._turn_end()
	queue_free()

func _on_random_pressed() -> void:
	get_parent()._take_damage(randi_range(0, 3), player) #body included, include destroyed parts
	player._turn_end()
	queue_free()

func _on_body_pressed() -> void:
	get_parent()._take_damage(3, player)
	player._turn_end()
	queue_free()
