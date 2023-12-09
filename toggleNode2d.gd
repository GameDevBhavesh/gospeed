extends ToolButton

export var to:NodePath
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var node:Control

var IsToggled =false
# Called when the node enters the scene tree for the first time.
func _ready():
	node = get_node(to)
	connect("button_up",self,"togglemore")
	pass # Replace with function body.

func togglemore():
	IsToggled =!IsToggled
	node.visible = !IsToggled
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
