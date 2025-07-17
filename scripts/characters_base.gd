extends CharacterBody2D
class_name CharacterBase

var body_parts = {
	"Head": true,
	"Arms": true,
	"Legs": true,
	"Body": true
}

@onready var tile_map = %MovementLayer
@export var SPEED = 200
var current_path: Array[Vector2i]

var is_my_turn = true
var health: int = 100
var max_health: int = 100

signal on_damaged(damage: int, attacker, part_destroyed: String)
signal on_dead()
#signal TurnEnd()
#signal TurnStart()

@onready var player2 = get_tree().get_nodes_in_group("player")[0]


func _on_damaged(dmg, attacker, part_destroyed):
	print(attacker.name, " нанёс ", dmg, " урона ", self.name)
	print(part_destroyed)

func _on_dead():
	print(self.name, " погиб")

func _ready() -> void:
	connect("on_damaged", _on_damaged)
	connect("on_dead", _on_dead)
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

func take_damage(damage: int, attacker) -> void:
	if(attacker is CharacterBase):
		health -= damage
		var part_destroyed = check_body_part_destroyed()
	
		emit_signal("on_damaged", damage, attacker, part_destroyed)
	
		if health <= 0:
			die()

func check_body_part_destroyed() -> String:
	var parts = body_parts.keys()
	for part in parts:
		if body_parts[part] and randf() <= 0.2:  # 20% шанс уничтожить часть
			body_parts[part] = false
			return part
	return "No"

func die() -> void:
	emit_signal("on_dead")
	queue_free()

func has_body_part(part: String) -> bool:
	return body_parts.get(part, false)
