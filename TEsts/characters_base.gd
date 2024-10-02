extends CharacterBody2D

@export var tile_map: TileMapLayer
@export var SPEED = 200
const tile_width = 16
var current_path: Array[Vector2i]

var health = 200
var damage = 10

var is_my_turn = true

signal OnDamaged( dmg, attacker)
signal OnDead()

func _on_damaged(dmg, attacker):
	print(attacker, " нанёс ", dmg, " урона ", self)

func _on_dead():
	print(self, " погиб")

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
		_death()

func _death():
	OnDead.emit()
	queue_free()
