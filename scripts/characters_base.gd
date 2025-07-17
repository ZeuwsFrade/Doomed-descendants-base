extends CharacterBody2D
class_name CharacterBase

<<<<<<< HEAD
var body_parts = {
	"Head": true,
	"Arms": true,
	"Legs": true,
	"Body": true
=======
class_name CharecterBase

#is_exist - внутрення функция для проверки сломана ли конечность
#chance - вероятность попадания по конечности random(0,1) <= chance
#vital - жизненонеобходима ли конечность. Если true, то после уничтожения её - сущность умрёт
#text - название на требуемом языке
#check - функция специфической проверки возможности слома конечности
@export var Parts = { 
	Body = {is_exist = true, chance = 0.75, vital = true, text = "Тело", check = is_some_part_broke}, #Сделать фигню чтоб шанс мог изменятся от внешних источников (предметы, и т.д.).
	Head = {is_exist = true, chance = 0.1, vital = true, text = "Голова"},
	Arms = {is_exist = true, chance = 0.5, vital = false, text = "Руки"},
	Legs = {is_exist = true, chance = 0.5, vital = false, text = "Ноги"},
>>>>>>> origin/master
}

@onready var tile_map = %MovementLayer
@export var SPEED = 200
var current_path: Array[Vector2i]

var is_my_turn = true
var health: int = 100
var max_health: int = 100

<<<<<<< HEAD
signal on_damaged(damage: int, attacker, part_destroyed: String)
signal on_dead()
#signal TurnEnd()
#signal TurnStart()

@onready var player2 = get_tree().get_nodes_in_group("player")[0]


func _on_damaged(dmg, attacker, part_destroyed):
=======
signal OnPartBroke( part )
signal OnDamaged( dmg, attacker )
signal OnDead()
#signal TurnEnd()
#signal TurnStart()

func _on_damaged(dmg, attacker) -> void:
>>>>>>> origin/master
	print(attacker.name, " нанёс ", dmg, " урона ", self.name)
	print(part_destroyed)

func _on_dead() -> void:
	print(self.name, " погиб")

func _ready() -> void:
<<<<<<< HEAD
	connect("on_damaged", _on_damaged)
	connect("on_dead", _on_dead)
=======
	connect("OnPartBroke", _on_part_broke)
	connect("OnDamaged", _on_damaged)
	connect("OnDead", _on_dead)
>>>>>>> origin/master
	_deploy()
	
func _deploy() -> void: #ready, но для дочерних нодов.
	pass
	
func is_some_part_broke() -> bool:
	if Parts.size() == 1:
		return true
	for i in Parts:
		if !Parts[i].is_exist:
				return true
	return false

func can_destroy_part(part) -> bool:
	if Parts[part].is_exist:
		if Parts[part].has("check"):
			return Parts[part]["check"].call()
		else:
			return true
	return false

<<<<<<< HEAD
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
=======
func _on_part_broke(part) -> void:
	print(self.name + "`s " + Parts[part].text + " is destroyed")

func _part_destroy(part):
	Parts[part].is_exist = false
	if Parts[part].vital:
		_die()
	OnPartBroke.emit(part)

func random_part() -> String:
	var i = Parts.keys().pick_random()
	while(true):
		if can_destroy_part(i):
			return i
		else:
			i = Parts.keys().pick_random()
	return ""

func _take_damage( part, attacker ) -> void:
	if part == null:
		var rnd_part = random_part()
		if randf() <= Parts[rnd_part].chance:
			_part_destroy(rnd_part)
	else:
		if can_destroy_part(part):
			if randf() <= Parts[part].chance:
				_part_destroy(part)
	

func _die() -> void:
	OnDead.emit()
>>>>>>> origin/master
	queue_free()

func has_body_part(part: String) -> bool:
	return body_parts.get(part, false)
