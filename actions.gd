extends HBoxContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var save_button_path:NodePath
export var tap_container_path:NodePath

var save_button:Button
var tab_container:CustomTabContainer

func _ready():

	save_button = get_node(save_button_path)

	save_button.connect("button_down",self,"save_current_tab_data")

	pass

func save_current_tab_data():
	tab_container.get_current_tab_content()
	pass


func insert_request_in_db(data):

	print("Inserting request ",data)
	$nodes_table.create({"parent_id":str(data.parent_id)})
	var node_id =  $nodes_table.db.instance.last_insert_rowid
	$node_data_table.create({"parent_id":str(node_id),"name":data.name,"type":data.type})
	var node_data_id =  $node_data_table.db.instance.last_insert_rowid
	$requests_table.create({"parent_id":str(node_data_id)})
	var inserted_request_node = $contents_table_view.details("id="+str(node_id))
	return inserted_request_node;
	
	pass
