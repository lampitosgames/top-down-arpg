extends Sprite

export(float) var cursorSpeed = 40.0

signal cursor_move(globalCoords)

var cursorPos
var cursorVel = Vector2(0, 0)

var lastPlayerPos = Vector2(0, 0)

func _ready():
	Input.set_mouse_mode(1)
	position = get_viewport_rect().position + get_viewport_rect().size/2
	emit_signal("cursor_move", position)

func _input(ev):
	if ev is InputEventMouseMotion:
		position = get_global_mouse_position()
		emit_signal("cursor_move", position)
	elif ev is InputEventJoypadMotion:
		#Vertical joystick movement
		if (ev.is_action("cursor_move_up") || ev.is_action("cursor_move_down")):
			cursorVel = Vector2(cursorVel.x, ev.axis_value)
		#Horizontal joystick movement
		if (ev.is_action("cursor_move_left") || ev.is_action("cursor_move_right")):
			cursorVel = Vector2(ev.axis_value, cursorVel.y)
		if (cursorVel.length_squared() < 0.01):
			cursorVel = Vector2(0,0)
		

func _process(delta):
	position += cursorVel * cursorSpeed
	if (cursorVel.length_squared() != 0):
		emit_signal("cursor_move", position)
	
	var viewportSize = get_viewport_rect().size
	var viewportPos = -get_viewport().canvas_transform.origin	
	position.x = clamp(position.x, viewportPos.x, viewportPos.x + viewportSize.x)
	position.y = clamp(position.y, viewportPos.y, viewportPos.y + viewportSize.y)


func _on_player_move(globalCoords):
	var positionDelta = globalCoords - lastPlayerPos
	lastPlayerPos = globalCoords
	position += positionDelta
	emit_signal("cursor_move", position)
