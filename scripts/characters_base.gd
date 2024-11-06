extends CharacterBody2D

class_name CharecterBase

#class Parts:
#	var Head: bool

var Parts = { Head = true, Arms = true, Legs = true, Body = true }

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
	if part == 0: # HEAD
		chance = randi_range(0,4)
		if chance == 0:
			self.Parts.Head = false
			return true
	elif part == 3: # Body
		chance = randi_range(0,2)
		if chance == 0:
			self.Parts.Body = false
			return true
	elif part == 2: # LEGS
		chance = randi_range(0,2)
		if chance == 0:
			self.Parts.Legs = false
			return true
	elif part == 1: # ARMS
		chance = randi_range(0,2)
		if chance == 0:
			self.Parts.Arms = false
			return true
	return false

func _take_damage( part, attacker ):
	if !_random(part):
		print(attacker.name, " attack missed")
		return
	if (!self.Parts.Head or !self.Parts.Body):
		if self != player2:
			_die()
	OnDamaged.emit(part, attacker)
	#if health < 0:
		#_die()

func _die():
	OnDead.emit()
	queue_free()
