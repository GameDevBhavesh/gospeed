extends VBoxContainer
class_name VBoxEditableList

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
# var a = 2

export var _item_node:PackedScene;
var item

func _ready():
	$Control/add.connect("button_down",self,"add_item")
	$Control/remove.connect("button_down",self,"remove_item")
	item = load(_item_node.resource_path)
	pass
# Called when the node enters the scene tree for the first time.
func add_item(key="",value=""):
	var ins_item = item.instance() as KeyValueInput
	ins_item._setpair({
		key=key,
		value=value
	})
	add_child(ins_item)
	if(get_child_count()>0):
		move_child(get_child(get_child_count()-2),get_child_count()-1) 
	pass # Replace with function body.
	
func remove_item():
	if(get_child_count()>1):
		get_child(get_child_count()-2).queue_free()
	
	pass # Replace with function body.
func get_keyvalue_items():
	var list= []
	var klist = get_children().duplicate()
	klist.remove(get_child_count()-1)
	for i in klist:
		var p =  i as KeyValueInput
		var kv = p._get_json_pair()
		list.push_front(kv.key+":"+kv.value)
		print(kv.key+":"+kv.value)
	return list;
	pass 

func set_keyvalue_items_from_dict(dict):
	for i in dict.keys():
		add_item(i,dict[i])
	pass 

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
