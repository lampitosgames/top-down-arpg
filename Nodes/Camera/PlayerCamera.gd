extends Node2D

var playerPosition = Vector2(0, 0)
var cursorPosition = Vector2(0, 0)

func _ready():
	pass

func _process(delta):
	position.x = lerp(playerPosition.x, cursorPosition.x, 0.3)
	position.y = lerp(playerPosition.y, cursorPosition.y, 0.3)
	
	var offset = position - $Camera.position

func _on_Player_player_move(globalCoords):
	playerPosition = globalCoords

func _on_Cursor_cursor_move(globalCoords):
	cursorPosition = globalCoords
