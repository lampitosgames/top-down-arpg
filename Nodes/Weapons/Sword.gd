extends Area2D

signal attack_finished

export(int) var weaponAttack = 10

onready var animatedSprite = $AnimatedSprite

enum ATTACK_STATE {ATTACK, NONE}
var state = NONE

onready var ownerNode = get_parent()

func _ready():
	visible = false
	set_physics_process(false)

func attack():
	animatedSprite.play("attack")
	visible = true
	_set_state(ATTACK)

func _physics_process(delta):
	#Get all physics bodies that collide with the weapon
	var overlappingBodies = get_overlapping_bodies()
	#If there are none, return and keep looking
	if not overlappingBodies:
		return
	#If there are overlapping bodies, loop through them
	for body in overlappingBodies:
		#Continue to the next if this one isn't damageable
		if not body.is_in_group("damageable"):
			continue
		#If overlapping the weapon's owner, obviously do nothing
		if _is_owner(body):
			#If the owner is the only body, return instead of proceeding so the process loop isn't cancelled
			if overlappingBodies.size() == 1:
				return
			#There are other bodies here
			else:
				continue
		#If a body passes all checks, tell the weapon's owner to deal damage
		ownerNode.deal_damage_to(body, weaponAttack)
	#Stop looking for bodies to hit since damage has been dealt
	set_physics_process(false)

func _set_state(newState):
	state = newState
	match newState:
		ATTACK:
			set_physics_process(true)
		NONE:
			set_physics_process(false)

func _is_owner(node):
	return node == get_parent()

func _on_AnimatedSprite_animation_finished():
	animatedSprite.stop()
	visible = false
	animatedSprite.frame = 0
	_set_state(NONE)
	emit_signal("attack_finished")
