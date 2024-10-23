extends CharacterBody2D

class_name CharecterBase

#class Parts:
#	var Head: bool
var Head = true
var Arms = true
var Legs = true
var Body = true

@onready var tile_map = %MovementLayer
@export var SPEED = 200
var current_path: Array[Vector2i]

var is_my_turn = true

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
	connect("OnDamaged", _on_damaged)
	connect("OnDead", _on_dead)
	_deploy()
	
func _deploy() -> void:
	pass

func _random( part ):
	var chance = 4
	if part == 0:
		chance = randi_range(0,4)
		if chance == 0:
			self.Head = false
			return true
	elif part == 3:
		chance = randi_range(0,2)
		if chance == 0:
			self.Body = false
			return true
	elif part == 2:
		chance = randi_range(0,2)
		if chance == 0:
			self.Legs = false
			return true
	elif part == 1:
		chance = randi_range(0,2)
		if chance == 0:
			self.Arms = false
			return true
	return false

func _take_damage( part, attacker ):
	if !_random(part):
		print(attacker.name, " attack missed")
		return
	if (!self.Head or !self.Body):
		if self != player2:
			_die()
	OnDamaged.emit(part, attacker)
	#if health < 0:
		#_die()

func _die():
	OnDead.emit()
	queue_free()
