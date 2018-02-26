extends CanvasLayer

signal cursor_move(globalCoords)

func _on_Player_player_move(globalCoords):
	$Cursor._on_player_move(globalCoords)

func _on_Player_player_update_move(dirNorm, dirPriority, keyboardInput):
	$Cursor._on_player_update_direction(dirNorm, dirPriority, keyboardInput)

func update_gui_transform(position):
	transform.origin = position
