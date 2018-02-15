extends RigidBody2D

#Maximum player speed without modifiers
export var playerSpeed = 300
#Player mass.  Lower means less inertia
export var playerMass = 10
#When the player stops inputting directional movement, how much linear damping is applied
export var stoppedLinearDamp = 40
#Force magnitude for movement.  Lower means more time to change
export var dirForceMag = 400

#Emitted signals
signal player_update_move(dirNorm, dirPriority, keyboardInput)
signal player_move(globalCoords)

#Move direction
var moveDir = Vector2(0, 0)
#North=0, East=1, South=2, West=3
var moveDirPriority = [false, false, false, false]

#Start
func _ready():
	set_process_input(true)
	set_mass(playerMass)
	set_friction(0)
	emit_signal("player_move", position)

#Update
func _physics_process(delta):
	#Clamp moveDir.  Controllers sometimes go over the given range of 0-1, so we need to cap the movement speeds
	moveDir = moveDir.clamped(1)
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
		set_linear_velocity(get_linear_velocity().clamped(playerSpeed * moveDir.length()))
		emit_signal("player_move", position)

#Handle input events.  Mostly used for movement, other controls are handled elsewhere
func _input(ev):
	#Keyboard input handling
	if ev is InputEventKey:
		keyboard_input(ev)
		emit_signal("player_update_move", moveDir, moveDirPriority, true)
	#Gamepad input handling (for key presses)
	if ev is InputEventJoypadButton:
		print("gamepad button")
	#Gamepad input handling for joystick movement
	if ev is InputEventJoypadMotion:
		gamepad_input(ev)
		emit_signal("player_update_move", moveDir, moveDirPriority, false)

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
	
	#Normalize the movement direction
	moveDir = moveDir.normalized()

func gamepad_input(ev):
	#Vertical joystick movement
	if (ev.is_action("player_move_up") || ev.is_action("player_move_down")):
		moveDir = Vector2(moveDir.x, ev.axis_value)
	#Horizontal joystick movement
	if (ev.is_action("player_move_left") || ev.is_action("player_move_right")):
		moveDir = Vector2(ev.axis_value, moveDir.y)
	
	#If the vector is tiny, set it to zero
	if (moveDir.length_squared() < 0.01):
		moveDir = Vector2(0, 0)
