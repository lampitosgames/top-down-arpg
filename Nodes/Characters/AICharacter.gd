extends "res://Nodes/Characters/Character.gd"

func start():
	.start()

func update_character(dt):
	get_steering()
	move_character(dt)

#Probably unique for all children.
func get_steering():
#	steering = AISteering.seek(position, Vector2(0, 0), maxAcceleration)
	steering = AISteering.match_velocity(linear_velocity, Vector2(0, 0))

func move_character(dt):
	#Move based on calculated steering.
	linear_velocity += steering
	#Clamp to maximum speed
	linear_velocity = linear_velocity.clamped(maxSpeed)
	#Remove negligable velocities to prevent stuttering
	if (linear_velocity.length_squared() < 0.1):
		linear_velocity = Vector2(0, 0)
