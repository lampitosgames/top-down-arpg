extends Node

func get_attack_data(baseDamage = 0, attackDirection = Vector2(1, 0), knockback = 0):
	return {
		"damage": baseDamage,
		"dir": attackDirection,
		"knockback": knockback	
	}