extends Node2D

#Node to follow in the tree
export(NodePath) var followNodePath

export(bool) var lerpToPosition = false
export(float) var lerpMag = 5.0

#Screen
onready var screenSize = get_viewport_rect().size
#Node to follow
onready var followNode = get_node(followNodePath)
#Clone this transform for the viewport
onready var viewportTransform = Transform2D(transform)

func _ready():
	get_tree().get_root().connect("size_changed",self,"_resize")
	#Set visibility based on debug settings
	visible = ProjectSettings.get_setting("debug/settings/display/display_camera_info")
	_resize()

func _resize():
	screenSize = get_viewport_rect().size
	if visible:
		$CanvasLayer.transform = Transform2D(Vector2(1, 0), Vector2(0, 1), screenSize/2)

func _process(delta):
	#If not lerping over time to the target position
	if !lerpToPosition:
		position = followNode.position
		#Set the viewport transform.  Account for screen size and scaling
		viewportTransform.origin = -followNode.position + (screenSize/2)
	else:
		var toTarget = followNode.position - position
		if !(toTarget.length_squared() < 0.01):
			var vel = toTarget * lerpMag
			position += vel * delta
		viewportTransform.origin = -position + (screenSize/2)
	
	#Make sure GUI controls aren't affected by the camera
	get_tree().call_group("GUICanvasLayers", "update_gui_transform", -followNode.position + (screenSize/2))
	
	get_viewport().canvas_transform = viewportTransform
