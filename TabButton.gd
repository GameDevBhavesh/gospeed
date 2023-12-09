extends "res://addons/material-design-icons/nodes/MaterialButton.gd"


export var view_id = 0
var tab_view:Control=null
# Called when the node enters the scene tree for the first time.
func _ready():
	connect("button_down",self,'set_view')
	pass # Replace with function body.

func set_view():
	
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
