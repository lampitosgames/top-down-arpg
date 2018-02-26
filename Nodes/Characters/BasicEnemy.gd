extends "res://Nodes/Characters/AICharacter.gd"

export(NodePath) var playerPath

onready var Player = get_node(playerPath)

func get_steering():
	steering = AISteering.seek(position, Player.position, maxAcceleration)