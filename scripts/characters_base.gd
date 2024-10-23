extends CharacterBody2D

class_name CharecterBase

@onready var tile_map = %MovementLayer
@export var SPEED = 200
var current_path: Array[Vector2i]

var health = 200
var damage = 10

var is_my_turn = true

signal OnDamaged( dmg, attacker )
signal OnDead()
#signal TurnEnd()
#signal TurnStart()



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

func _take_damage( dmg, attacker ):
	health = health - dmg
	OnDamaged.emit(dmg, attacker)
	if health < 0:
		_die()

func _die():
	OnDead.emit()
	queue_free()
