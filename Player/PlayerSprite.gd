extends AnimatedSprite

export var northRunSpeed = 15
export var eastRunSpeed = 13
export var southRunSpeed = 15
export var westRunSpeed = 13

var lastMoveDir = 2

func _player_moved(dir, priority, keyboardInput):	
	#check for stopped
	if (dir.length_squared() == 0):
		if (lastMoveDir == 0):
			play("idle-north")
			offset = Vector2(0, 0)
		elif (lastMoveDir == 1):
			play("idle-east")
			offset = Vector2(0, 0)
		elif (lastMoveDir == 2):
			play("idle-south")
			offset = Vector2(0, 0)
		elif (lastMoveDir == 3):
			play("idle-west")
			offset = Vector2(0, 0)
		return
	
	if (keyboardInput):
		handle_keyboard(dir, priority)
	else:
		handle_gamepad(dir)

func handle_keyboard(dir, priority):
	if (priority[0]):
		lastMoveDir = 0
		play("run-north")
		frames.set_animation_speed("run-north", northRunSpeed)
		offset = Vector2(0, 0)
	elif (priority[1]):
		lastMoveDir = 1
		play("run-east")
		frames.set_animation_speed("run-east", eastRunSpeed)
		offset = Vector2(-20, 0)
	elif (priority[2]):
		lastMoveDir = 2
		play("run-south")
		frames.set_animation_speed("run-south", southRunSpeed)
		offset = Vector2(0, 0)
	elif (priority[3]):
		lastMoveDir = 3
		play("run-west")
		frames.set_animation_speed("run-west", westRunSpeed)
		offset = Vector2(20, 0)

func handle_gamepad(dir):
	#check for north/south animation
	if (abs(dir.x) < abs(dir.y)):
		if (dir.y < 0):
			lastMoveDir = 0
			play("run-north")
			frames.set_animation_speed("run-north", range_lerp(dir.y, 0, -1, 5, northRunSpeed))
			offset = Vector2(0, 0)
		elif (dir.y > 0):
			lastMoveDir = 2
			play("run-south")
			frames.set_animation_speed("run-south", range_lerp(dir.y, 0, 1, 5, southRunSpeed))
			offset = Vector2(0, 0)
	#check for east/west animation
	elif (abs(dir.y) < abs(dir.x)):
		if (dir.x < 0):
			lastMoveDir = 3
			play("run-west")
			frames.set_animation_speed("run-west", range_lerp(dir.x, 0, -1, 5, westRunSpeed))
			offset = Vector2(20, 0)
		elif (dir.x > 0):
			lastMoveDir = 1
			play("run-east")
			frames.set_animation_speed("run-east", range_lerp(dir.x, 0, 1, 5, eastRunSpeed))
			offset = Vector2(-20, 0)
