extends "res://Nodes/Characters/AICharacter.gd"

func get_steering():
	steering = AISteering.pursue(self, GameState.Player, 3)