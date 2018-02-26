extends Node2D

func _ready():
	make_connections()

func make_connections():
	$Player.connect("player_move", $PlayerCamera, "_on_Player_player_move")
	$Player.connect("player_move", $Cursor, "_on_Player_player_move")
	$Player.connect("player_update_move", $Cursor, "_on_Player_player_update_move")
	$Cursor.connect("cursor_move", $PlayerCamera, "_on_Cursor_cursor_move")
	$Cursor.connect("cursor_move", $Player, "_on_Cursor_cursor_move")
	