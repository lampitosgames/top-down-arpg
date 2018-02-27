extends "res://Nodes/Characters/Character.gd"


#Emitted signals
signal player_update_move(dirNorm, dirPriority, keyboardInput)
signal player_move(globalCoords)
signal player_attack(dir)
signal player_attack_finished()

#When the player stops inputting directional movement, how much linear damping is applied
export var stoppedLinearDamp = 40
#Force magnitude for movement.  Lower means more time to change
export var dirForceMag = 400

#Path to the equipped weapon
export(NodePath) var weaponPath
#When the player attacks, how much linear damping is applied
export var attackingLinearDamp = 30


#Move direction
var moveDir = Vector2(0, 0)
#North=0, East=1, South=2, West=3
var moveDirPriority = [false, false, false, false]
#cursor position
var cursorPos = Vector2(0, 0)
#Player's currently equipped weapon
var equippedWeapon = null

#Player state variables
enum playerState {DEFAULT, ATTACKING, DASHING}
var currentState = playerState.DEFAULT


func _init():
	GameState.Player = self

func start():
	.start()
	set_process_input(true)
	friction = 0
	
	connect("player_update_move", $AnimatedSprite, "_player_moved")
	connect("player_attack", $AnimatedSprite, "_player_attack")
	connect("player_attack_finished", $AnimatedSprite, "_player_attack_finished")
	if (has_node(weaponPath)):
		equippedWeapon = get_node(weaponPath)
		equippedWeapon.connect("attack_finished", self, "_on_Weapon_attack_finished")
	emit_signal("player_move", position)

func move_character(dt):
	#Clamp moveDir.  Controllers sometimes go over the given range of 0-1, so we need to cap the movement speeds
	moveDir = moveDir.clamped(1)
	
	#If the player is locked into an animation
	if (currentState != playerState.DEFAULT):
		emit_signal("player_move", position)
		return
	
	#If player is stopped
	if (moveDir.length_squared() == 0):
		set_linear_damp(stoppedLinearDamp)
		set_applied_force(Vector2(0,0))
	#Else, they are moving
	else:
		#Clear linear damp
		set_linear_damp(0)
		#ALWAYS FIRST
		#Calculate a move force and apply it
		var moveForce = moveDir * dirForceMag * dirForceMag
		set_applied_force(moveForce)
		#Clamp player's linear velocity
		set_linear_velocity(get_linear_velocity().clamped(maxSpeed * moveDir.length()))
		emit_signal("player_move", position)

#Handle input events.  Mostly used for movement, other controls are handled elsewhere
func _input(ev):
	#Keyboard input handling
	if ev is InputEventKey:
		keyboard_input(ev)
		emit_signal("player_update_move", moveDir, moveDirPriority, true)
	if ev is InputEventMouse:
		keyboard_input(ev)
	#Gamepad input handling (for key presses)
	if ev is InputEventJoypadButton:
		if ev.is_action_pressed("player_attack"):
			attack()
	#Gamepad input handling for joystick movement
	if ev is InputEventJoypadMotion:
		gamepad_input(ev)
		emit_signal("player_update_move", moveDir, moveDirPriority, false)

func attack():
	if not equippedWeapon || currentState != playerState.DEFAULT:
		return
	
	#Get a unit vector in the direction of the cursor for the attack
	var attackDir = position - cursorPos
	attackDir = attackDir.normalized()
	#Get tangent vector to the attack normal so we can build a rotation matrix
	var attackTangent = attackDir.tangent().normalized()
	#Change the equipped weapon's transform to point in the right direction
	equippedWeapon.transform = Transform2D(attackTangent, attackDir, attackDir * -30)
	#Call the weapon's attack method.  When it finishes, it will emit a signal
	equippedWeapon.attack()
	
	#Set the player state to attacking
	currentState = playerState.ATTACKING
	#Reset the player's velocity
	linear_velocity = Vector2(0, 0)
	set_applied_force(Vector2(0,0))
	set_linear_damp(attackingLinearDamp)
	apply_impulse(Vector2(0, 0), attackDir * -2000 * mass)
	
	emit_signal("player_attack", -attackDir)

func _on_Weapon_attack_finished():
	currentState = playerState.DEFAULT
	emit_signal("player_update_move", moveDir, moveDirPriority, false)
	emit_signal("player_attack_finished")

#Track cursor position
func _on_Cursor_cursor_move(globalCoords):
	cursorPos = globalCoords

####################################################
#                                                  #
# Seperate input handlers for keyboard and gamepad #
#                                                  #
####################################################
func keyboard_input(ev):
	#Up is pressed
	if (ev.is_action_pressed("player_move_up")):
		#Set the direction
		moveDir = Vector2(moveDir.x, -1)
		moveDirPriority[2] = false
		moveDirPriority[0] = !moveDirPriority[1] && !moveDirPriority[3]
	#Up is released
	if (ev.is_action_released("player_move_up")):
		#If down is currently pressed, move down
		if (Input.is_action_pressed("player_move_down")):
			moveDir = Vector2(moveDir.x, 1)
			#Set directional priorities
			moveDirPriority[0] = false
			moveDirPriority[2] = !moveDirPriority[1] && !moveDirPriority[3]
		else:
			moveDir = Vector2(moveDir.x, 0)
			#Set directional priorities
			moveDirPriority[0] = false
			if (moveDir.x > 0):
				moveDirPriority[1] = true
			elif (moveDir.x < 0):
				moveDirPriority[3] = true

	#Right is pressed
	if (ev.is_action_pressed("player_move_right")):
		moveDir = Vector2(1, moveDir.y)
		moveDirPriority[3] = false
		moveDirPriority[1] = !moveDirPriority[0] && !moveDirPriority[2]
	#Right is released
	if (ev.is_action_released("player_move_right")):
		if (Input.is_action_pressed("player_move_left")):
			moveDir = Vector2(-1, moveDir.y)
			#Set directional priorities
			moveDirPriority[1] = false
			moveDirPriority[3] = !moveDirPriority[0] && !moveDirPriority[2]
		else:
			moveDir = Vector2(0, moveDir.y)
			#Set directional priorities
			moveDirPriority[1] = false
			if (moveDir.y < 0):
				moveDirPriority[0] = true
			elif (moveDir.y > 0):
				moveDirPriority[2] = true

	#Down is pressed
	if (ev.is_action_pressed("player_move_down")):
		moveDir = Vector2(moveDir.x, 1)
		moveDirPriority[0] = false
		moveDirPriority[2] = !moveDirPriority[1] && !moveDirPriority[3]
	#Down is released
	if (ev.is_action_released("player_move_down")):
		if (Input.is_action_pressed("player_move_up")):
			moveDir = Vector2(moveDir.x, -1)
			#Set directional priorities
			moveDirPriority[2] = false
			moveDirPriority[0] = !moveDirPriority[1] && !moveDirPriority[3]
		else:
			moveDir = Vector2(moveDir.x, 0)
			#Set directional priorities
			moveDirPriority[2] = false
			if (moveDir.x > 0):
				moveDirPriority[1] = true
			elif (moveDir.x < 0):
				moveDirPriority[3] = true

	#Left is pressed
	if (ev.is_action_pressed("player_move_left")):
		moveDir = Vector2(-1, moveDir.y)
		moveDirPriority[1] = false
		moveDirPriority[3] = !moveDirPriority[0] && !moveDirPriority[2]
	#Left is released
	if (ev.is_action_released("player_move_left")):
		if (Input.is_action_pressed("player_move_right")):
			moveDir = Vector2(1, moveDir.y)
			#Set directional priorities
			moveDirPriority[3] = false
			moveDirPriority[1] = !moveDirPriority[0] && !moveDirPriority[2]
		else:
			moveDir = Vector2(0, moveDir.y)
			#Set directional priorities
			moveDirPriority[3] = false
			if (moveDir.y < 0):
				moveDirPriority[0] = true
			elif (moveDir.y > 0):
				moveDirPriority[2] = true
	
	if (ev.is_action_pressed("player_attack")):
		attack()
	
	#Normalize the movement direction
	moveDir = moveDir.normalized()

func gamepad_input(ev):
	#Vertical joystick movement
	if (ev.is_action("player_move_up") || ev.is_action("player_move_down")):
		moveDir = Vector2(moveDir.x, ev.axis_value)
	#Horizontal joystick movement
	if (ev.is_action("player_move_left") || ev.is_action("player_move_right")):
		moveDir = Vector2(ev.axis_value, moveDir.y)
	
	if (ev.is_action_pressed("player_attack")):
		attack()
	
	#If the vector is tiny, set it to zero
	if (moveDir.length_squared() < 0.01):
		moveDir = Vector2(0, 0)