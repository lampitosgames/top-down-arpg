extends Node

const DEFAULT_MAX_SPEED = 600
const DEFAULT_MAX_ACCEL = 40

#Seek a position
static func seek(pos, targetPos, maxAccel = DEFAULT_MAX_ACCEL):
	var direction = targetPos - pos
	var steering = direction.normalized() * maxAccel
	return steering

#Flee a position (opposite of seek)
static func flee(pos, targetPos, maxAccel = DEFAULT_MAX_ACCEL):
	var direction = pos - targetPos
	var steering = direction.normalized() * maxAccel
	return steering

#Arrive at a position
static func arrive(pos, targetPos, currentVel, timeToTarget = 0.5, slowRadius = 200, maxSpeed = DEFAULT_MAX_SPEED, maxAccel = DEFAULT_MAX_ACCEL, satisfactionRadius = 1.0):
	var direction = targetPos - pos
	var dist = direction.length()
	if (dist < satisfactionRadius):
		return Vector2(0, 0)
	var targetSpeed
	if dist > slowRadius:
		targetSpeed = maxSpeed
	else:
		targetSpeed = maxSpeed * dist / slowRadius
	var desiredVel = direction.normalized() * targetSpeed
	var steering = (desiredVel - currentVel) / timeToTarget
	steering = steering.clamped(maxAccel)
	return steering

static func match_velocity(currentVel, targetVel, timeToTarget = 0.3, maxAccel = DEFAULT_MAX_ACCEL):
	var steering = (targetVel - currentVel) / timeToTarget
	steering = steering.clamped(maxAccel)
	return steering
