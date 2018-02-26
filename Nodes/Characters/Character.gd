extends RigidBody2D


#Character's health
export(float) var health = 100
#Maximum speed for the character
export(float) var maxSpeed = 300
#Maximum acceleration for the character
export(float) var maxAcceleration = 80
#Accumulated steering behaviors
export(Vector2) var steering = Vector2(0, 0)

#Emitted signals
signal character_move(nodePath, globalCoords)

#This character's path
onready var thisCharacter = get_path()
#Debug display
onready var displayDebugForces = ProjectSettings.get_setting("debug/settings/display/actor_forces")


#Call start so that the ready method can be overridden
func _ready():
	start()
#Call update so the update method can be overridden
func _physics_process(delta):
	update_character(delta)
	if displayDebugForces:
		update()

#Start
func start():
	emit_signal("character_move", thisCharacter, position)

#Update
func update_character(dt):
	move_character(dt)

func _draw():
	if displayDebugForces:
		draw_line(Vector2(0, 0), linear_velocity, Color(0, 0, 255), 1.0)
		draw_line(Vector2(0, 0), steering, Color(255, 0, 0), 1.0)

#Movement-based update
func move_character(dt):
	pass

func deal_damage_to(otherNode, weaponDamage):
	if not otherNode.is_in_group("damageable"):
		return
	otherNode.apply_damage(Meta.get_attack_data(weaponDamage))

#Deal damage to this character
func apply_damage(damageObj):
	print("takes damage!")
	health -= damageObj.damage