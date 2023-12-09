extends Button


onready var tabcontainer = get_node("../../../RightPanel/VBoxContainer/CustomTabContainer")
var tabpanel = preload("res://src/Components/HttpTab.tscn")



# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("button_down",self,"_add_new_httptab")
	pass # Replace with function body.
	
func _add_new_httptab():
	var tabinstance = tabpanel.instance()
	var count = tabcontainer.get_tab_count()
	tabinstance.set_name("tab "+ String(count))
	tabcontainer.add_tab(tabinstance)
	
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
