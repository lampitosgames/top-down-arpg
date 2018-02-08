extends Node2D
#Node to follow in the tree
export(NodePath) var followNodePath

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

func _resize():
	screenSize = get_viewport_rect().size

func _process(delta):	
	#Set the viewport transform.  Account for screen size and scaling
	viewportTransform.origin = -followNode.position + (screenSize/2)
	
	get_viewport().canvas_transform = viewportTransform
