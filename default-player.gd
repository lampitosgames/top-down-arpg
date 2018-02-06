extends KinematicBody2D

export var playerSpeed = 500

var moveDir = Vector2(0, 0)
var lastMoveDir = 2

func _ready():
	set_process_input(true)
	$CollisionShape2D.visible = true
	$AnimatedSprite.play("idle-south")

func _physics_process(delta):
	var velocity = moveDir.normalized() * playerSpeed * delta;
	move_and_collide(velocity)
	
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
	
	#Finally, change animation based on the move direction vector
	moveDir = moveDir.normalized()
	
	var spr = $AnimatedSprite
	var sprFrames = spr.frames
	#check for stopped
	if (moveDir.length_squared() == 0):
		if (lastMoveDir == 0):
			spr.play("idle-north")
		elif (lastMoveDir == 1):
			spr.play("idle-east")
		elif (lastMoveDir == 2):
			spr.play("idle-south")
		elif (lastMoveDir == 3):
			spr.play("idle-west")
		return
	#check for north/south animation
	if (abs(moveDir.x) < 0.7):
		if (moveDir.y < 0):
			lastMoveDir = 0
			spr.play("run-north")
		elif (moveDir.y > 0):
			lastMoveDir = 2
			spr.play("run-south")
	#check for east/west animation
	elif (abs(moveDir.y) < 0.8):
		if (moveDir.x < 0):
			lastMoveDir = 3
			spr.play("run-west")
		elif (moveDir.x > 0):
			lastMoveDir = 1
			spr.play("run-east")

