extends Node

const DEFAULT_MAX_SPEED = 600
const DEFAULT_MAX_ACCEL = 30

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

#Match a specefied velocity (if target is 0, this is very useful for pushable objects.  Acts as linear damping)
static func match_velocity(currentVel, targetVel, timeToTarget = 0.3, maxAccel = DEFAULT_MAX_ACCEL):
	var steering = (targetVel - currentVel) / timeToTarget
	steering = steering.clamped(maxAccel)
	return steering

#Predictive seek, where a lookahead is used to predict the target's future position and seek that instead of the current position
static func pursue(thisObj, targetObj, maxPrediction = 5):
	if (thisObj == null || targetObj == null):
		return Vector2(0, 0)
	var direction = targetObj.position - thisObj.position
	var distance = direction.length()
	
	#get current speed
	var speed = thisObj.linear_velocity.length()
	
	var prediction
	if speed <= distance / maxPrediction:
		prediction = maxPrediction
	else:
		prediction = distance / speed
	
	var predictedTargetPos = targetObj.position + targetObj.linear_velocity * prediction
	return seek(thisObj.position, predictedTargetPos)