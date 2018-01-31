extends KinematicBody2D

export var playerSpeed = 10

var moveDirection = Vector2(0, 0)

signal player_is_moving;

func _ready():
	set_process_input(true)

func _physics_process(delta):
	print(moveDirection)
	pass
	
func _input(ev):
	# Move up input
	if (ev.is_action_pressed("player_move_up")):
		moveDirection += Vector2(0, 1)
	if (ev.is_action_released("player_move_up")):
		moveDirection -= Vector2(0, 1)
	# Move down input
	if (ev.is_action_pressed("player_move_down")):
		moveDirection += Vector2(0, -1)
	if (ev.is_action_released("player_move_down")):
		moveDirection -= Vector2(0, -1)
	# Move left input
	if (ev.is_action_pressed("player_move_left")):
		moveDirection += Vector2(-1, 0)
	if (ev.is_action_released("player_move_left")):
		moveDirection -= Vector2(-1, 0)
	# Move right input
	if (ev.is_action_pressed("player_move_right")):
		moveDirection += Vector2(1, 0)
	if (ev.is_action_released("player_move_right")):
		moveDirection -= Vector2(1, 0)
	
