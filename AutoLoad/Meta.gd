extends Node

func getAttackData(baseDamage = 0, attackDirection = Vector2(1, 0), knockback = 0):
	return {
		"damage": baseDamage,
		"dir": attackDirection,
		"knockback": knockback	
	}