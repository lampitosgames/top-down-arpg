extends Node2D

var playerPosition = Vector2(0, 0)
var cursorPosition = Vector2(0, 0)

func _ready():
	pass

func _process(delta):
	position.x = lerp(playerPosition.x, cursorPosition.x, 0.2)
	position.y = lerp(playerPosition.y, cursorPosition.y, 0.2)

func _on_player_move(globalCoords):
	playerPosition = globalCoords

func _on_cursor_move(globalCoords):
	cursorPosition = globalCoords
