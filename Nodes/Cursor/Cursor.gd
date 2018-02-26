extends Sprite

export(float) var cursorRadius = 400.0
export(float) var cursorSpeed = 40.0

var isGamepadActive = false
var aimingMode = false

var cursorPos
var cursorVel = Vector2(0, 0)

var lastPlayerPos = Vector2(0, 0)
var lastPlayerDir = Vector2(0, 1)

func _ready():
	Input.set_mouse_mode(1)
	position = get_viewport_rect().position + get_viewport_rect().size/2
	get_parent().emit_signal("cursor_move", position)

func _input(ev):
	if ev is InputEventMouseMotion:
		position = get_global_mouse_position()
		get_parent().emit_signal("cursor_move", position)
		if isGamepadActive:
			visible = true
			isGamepadActive = false
	elif ev is InputEventJoypadButton:
		if (ev.is_action_pressed("aim_cursor")):
			aimingMode = true
			visible = true
			position = lastPlayerPos + lastPlayerDir * cursorRadius
		elif (ev.is_action_released("aim_cursor")):
			aimingMode = false
			visible = false
			position = lastPlayerPos + lastPlayerDir * cursorRadius
			get_parent().emit_signal("cursor_move", position)
	elif ev is InputEventJoypadMotion:
		#Check gamepad active
		if !isGamepadActive:
			visible = false
			isGamepadActive = true
		
		#If the player is aiming specifically, give precise control over the cursor
		if (aimingMode):
			#Vertical joystick movement
			if (ev.is_action("cursor_move_up") || ev.is_action("cursor_move_down")):
				cursorVel = Vector2(cursorVel.x, ev.axis_value)
			#Horizontal joystick movement
			if (ev.is_action("cursor_move_left") || ev.is_action("cursor_move_right")):
				cursorVel = Vector2(ev.axis_value, cursorVel.y)
			if (cursorVel.length_squared() < 0.01):
				cursorVel = Vector2(0,0)
		#Otherwise, just move the cursor automatically
		else:
			cursorVel = Vector2(0,0)
			position = lastPlayerPos + lastPlayerDir * cursorRadius
			get_parent().emit_signal("cursor_move", position)

func _process(delta):
	position += cursorVel * cursorSpeed
	if (cursorVel.length_squared() != 0):
		get_parent().emit_signal("cursor_move", position)
	
	var viewportSize = get_viewport_rect().size
	var viewportPos = -get_viewport().canvas_transform.origin
	position.x = clamp(position.x, viewportPos.x, viewportPos.x + viewportSize.x)
	position.y = clamp(position.y, viewportPos.y, viewportPos.y + viewportSize.y)


func _on_player_move(globalCoords):
	var positionDelta = globalCoords - lastPlayerPos
	lastPlayerPos = globalCoords
	position += positionDelta
	get_parent().emit_signal("cursor_move", position)


func _on_player_update_direction(dirNorm, dirPriority, keyboardInput):
	if isGamepadActive:
		if (dirNorm.length_squared() != 0):
			lastPlayerDir = dirNorm.normalized()
