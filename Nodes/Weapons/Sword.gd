extends Area2D

signal attack_finished

export(NodePath) var ownerPath
export(int) var weaponAttack = 10

onready var animationPlayer = $AnimatedSprite

enum ATTACK_STATE {ATTACK, NONE}
var state = NONE

func _ready():
	set_physics_process(false)

func attack():
	_set_state(ATTACK)

func _physics_process(delta):
	var overlappingBodies = get_overlapping_bodies()
	
	if not overlappingBodies:
		return
		
	for body in overlappingBodies:
		if not body.is_in_group("damageable"):
			return
		if _is_owner(body):
			return
		
		body.apply_damage(weaponAttack)
	set_physics_process(false)

func _set_state(newState):
	state = newState
	match newState:
		ATTACK:
			set_physics_process(true)
		NONE:
			set_physics_process(false)

func _is_owner(node):
	return node.get_path() == ownerPath