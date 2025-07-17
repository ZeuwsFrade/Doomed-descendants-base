extends Control

var btn_arms: Button
var btn_legs: Button
var btn_head: Button
var btn_random: Button
var btn_body: Button

var attacker: Node
var target: Node

func _ready():
	_safe_initialize()

func _safe_initialize():
	var vbox = $VBoxContainer
	for child in vbox.get_children():
		match child.name:
			"Arms":
				btn_arms = child as Button
			"Legs":
				btn_legs = child as Button
			"Head":
				btn_head = child as Button
			"Random":
				btn_random = child as Button
			"Body":
				btn_body = child as Button
	
	if !btn_arms or !btn_legs or !btn_head or !btn_random or !btn_body:
		printerr("Не удалось инициализировать кнопки:")
		printerr("Arms:", btn_arms, " Legs:", btn_legs, " Head:", btn_head, " Random:", btn_random, " Body:", btn_body)
		queue_free()
		return
	
	_update_buttons_state()

func setup(attacker_node, target_node):
	attacker = attacker_node
	target = target_node
	_safe_initialize()

func _update_buttons_state():
	if !is_instance_valid(btn_body): return
	
	btn_body.disabled = true
	if not get_parent().has_body_part("Head"):
		btn_head.disabled = true
		btn_body.disabled = false
	if not get_parent().has_body_part("Arms"):
		btn_arms.disabled = true
		btn_body.disabled = false
	if not get_parent().has_body_part("Legs"):
		btn_legs.disabled = true
		btn_body.disabled = false
	if not get_parent().has_body_part("Body"):
		btn_body.disabled = true


func _on_arms_pressed() -> void:
	var weapon = DamageSystem.Weapon.new(10, DamageSystem.DamageType.PHYSICAL)
	var result = DamageSystem.calculate_damage(attacker, target, weapon)
	if result.hit_success:
		target.take_damage(result.damage_dealt, attacker)
	attacker._turn_end()
	queue_free()

func _on_legs_pressed() -> void:
	var weapon = DamageSystem.Weapon.new(8, DamageSystem.DamageType.PHYSICAL)
	var result = DamageSystem.calculate_damage(attacker, target, weapon)
	if result.hit_success:
		target.take_damage(result.damage_dealt, attacker)
	attacker._turn_end()
	queue_free()

func _on_head_pressed() -> void:
	var weapon = DamageSystem.Weapon.new(15, DamageSystem.DamageType.PHYSICAL, 0.6) # Меньше шанс попадания
	var result = DamageSystem.calculate_damage(attacker, target, weapon)
	if result.hit_success:
		target.take_damage(result.damage_dealt, attacker)
	attacker._turn_end()
	queue_free()

func _on_random_pressed() -> void:
	var types = [DamageSystem.DamageType.PHYSICAL, DamageSystem.DamageType.FIRE, DamageSystem.DamageType.POISON]
	var weapon = DamageSystem.Weapon.new(randi_range(5, 15), types[randi() % types.size()])
	var result = DamageSystem.calculate_damage(attacker, target, weapon)
	if result.hit_success:
		target.take_damage(result.damage_dealt, attacker)
	attacker._turn_end()
	queue_free()

func _on_body_pressed() -> void:
	var weapon = DamageSystem.Weapon.new(12, DamageSystem.DamageType.PHYSICAL)
	var result = DamageSystem.calculate_damage(attacker, target, weapon)
	if result.hit_success:
		target.take_damage(result.damage_dealt, attacker)
	attacker._turn_end()
	queue_free()
