extends KinematicBody2D

export var playerSpeed = 500

var moveDir = Vector2(0, 0)

func _ready():
	set_process_input(true)

func _physics_process(delta):
	var velocity = moveDir.normalized() * playerSpeed * delta;
	position += velocity;
	
func _input(ev):
	##
	## All of this logic only works for keyboard input
	##
	#Up is pressed
	if (ev.is_action_pressed("player_move_up")):
		#Set the direction
		moveDir = Vector2(moveDir.x, -1)
		
	#Up is released
	if (ev.is_action_released("player_move_up")):
		#If down is currently pressed, move down
		if (Input.is_action_pressed("player_move_down")):
			moveDir = Vector2(moveDir.x, 1)
		else:
			moveDir = Vector2(moveDir.x, 0)
			
	# Move right input
	if (ev.is_action_pressed("player_move_right")):
		moveDir = Vector2(1, moveDir.y)
	if (ev.is_action_released("player_move_right")):
		if (Input.is_action_pressed("player_move_left")):
			moveDir = Vector2(-1, moveDir.y)
		else:
			moveDir = Vector2(0, moveDir.y)
		
	# Move down input
	if (ev.is_action_pressed("player_move_down")):
		moveDir = Vector2(moveDir.x, 1)
	if (ev.is_action_released("player_move_down")):
		if (Input.is_action_pressed("player_move_up")):
			moveDir = Vector2(moveDir.x, -1)
		else:
			moveDir = Vector2(moveDir.x, 0)
			
	# Move left input
	if (ev.is_action_pressed("player_move_left")):
		moveDir = Vector2(-1, moveDir.y)
	if (ev.is_action_released("player_move_left")):
		if (Input.is_action_pressed("player_move_right")):
			moveDir = Vector2(1, moveDir.y)
		else:
			moveDir = Vector2(0, moveDir.y)
