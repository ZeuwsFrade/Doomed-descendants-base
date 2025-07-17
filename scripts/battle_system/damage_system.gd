extends Node
class_name DamageSystem


enum DamageType {
	PHYSICAL,
	FIRE,
	POISON,
	MAGIC
}

class Weapon:
	var base_damage: int
	var damage_type: DamageType
	var hit_chance: float
	
	func _init(dmg: int, type: DamageType, chance: float = 0.8):
		base_damage = dmg
		damage_type = type
		hit_chance = chance

class AttackResult:
	var damage_dealt: int
	var was_critical: bool
	var hit_success: bool
	var part_destroyed: String
	
	func _init(dmg: int, crit: bool, hit: bool, part: String = ""):
		damage_dealt = dmg
		was_critical = crit
		hit_success = hit
		part_destroyed = part

static func calculate_damage(attacker, defender, weapon: Weapon) -> AttackResult:
	if(attacker is CharacterBase and defender is CharacterBase):
		var hit_roll = randf()
		var hit_success = hit_roll <= weapon.hit_chance
	
		if not hit_success:
			return AttackResult.new(0, false, false)
	
		var crit_chance = 0.1  # Базовая вероятность крита
		var is_critical = randf() <= crit_chance
		var damage = weapon.base_damage
	
		if is_critical:
			damage *= 1.5
	
		# Проверка на уничтожение части тела
		var part_destroyed = ""
		if randf() <= 0.2:  # 20% шанс уничтожить часть тела
			var parts = ["Head", "Arms", "Legs", "Body"]
			part_destroyed = parts[randi() % parts.size()]
			defender.set(part_destroyed, false)
	
		return AttackResult.new(damage, is_critical, true, part_destroyed)
	else:
		return null
