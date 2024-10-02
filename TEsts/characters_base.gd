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

func _take_damage( dmg, attacker ):
	health = health - dmg
	OnDamaged.emit(dmg, attacker)
	if health < 0:
		_death()
	

func _death():
	OnDead.emit()
	queue_free()
