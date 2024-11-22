extends CharacterBody2D

class_name CharecterBase

var Parts = { 
	Body = {is_exist = true, chance = 0.75, vital = true, text = "Тело"}, #Обязательный параметр (Body)!
	Head = {is_exist = true, chance = 0.1, vital = true, text = "Голова"},
	Arms = {is_exist = true, chance = 0.5, vital = false, text = "Руки"},
	Legs = {is_exist = true, chance = 0.5, vital = false, text = "Ноги"},
}

@onready var tile_map = %MovementLayer
@export var SPEED = 200
var current_path: Array[Vector2i]

var is_my_turn = true

signal OnPartBroke( part )
signal OnDamaged( dmg, attacker )
signal OnDead()
#signal TurnEnd()
#signal TurnStart()

@onready var player2 = get_tree().get_nodes_in_group("player")[0]


func _on_damaged(dmg, attacker):
	print(attacker.name, " нанёс ", dmg, " урона ", self.name)

func _on_dead():
	print(self.name, " погиб")

func _ready() -> void:
	connect("OnPartBroke", _on_part_broke)
	connect("OnDamaged", _on_damaged)
	connect("OnDead", _on_dead)
	_deploy()
	
func _deploy() -> void:
	pass
	
func _can_attacked_body():#not include is_exist for body
	if Parts.size() == 1:
		return true
	for i in Parts:
		if !Parts[i].is_exist:
				return true
	return false

func _can_attacked_part(part):
	if part != "Body":
		if Parts[part].is_exist:
			return true
	else:
		if _can_attacked_body():
			return true
	return false

func _on_part_broke(part):
	print(self.name + "`s " + Parts[part].text + " is destroyed")

func _part_destroy(part):
	Parts[part].is_exist = false
	if Parts[part].vital:
		_die()
	OnPartBroke.emit(part)

func _random_part():
	var i = Parts.keys().pick_random()
	while(true):
		if _can_attacked_part(i):
			return i
		else:
			i = Parts.keys().pick_random()

func _take_damage( part, attacker ):
	if part == null:
		var rnd_part = _random_part()
		if randf() <= Parts[rnd_part].chance:
			_part_destroy(rnd_part)
	else:
		if _can_attacked_part(part):
			if randf() <= Parts[part].chance:
				_part_destroy(part)
	

func _die():
	OnDead.emit()
	queue_free()
