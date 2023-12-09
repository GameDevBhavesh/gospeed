extends Tree


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var contents_model_node:NodePath
export var _tab_container_path:NodePath
export var _options_context_node:NodePath
var options_context:PopupMenu
var tab_container:CustomTabContainer
var contents_model:RequestsTable
const PROJECT_PATH = "user://project1.json"

var tabpanel = preload("res://src/Components/HttpTab.tscn")

onready var icons1 = get_node("/root/Icons")

# Called when the node enters the scene tree for the first time.
func _ready():
	
	#tree signals
	connect("cell_selected",self,"tree_item_selected")
	connect("cell_selected",self,"on_tree_item_left_click")
	connect("item_rmb_selected",self,"on_tree_item_right_click")
	connect("item_edited",self,"on_tree_item_edited")
	connect("empty_tree_rmb_selected",self,"on_tree_item_right_click")

	#other references
	tab_container=get_node(_tab_container_path)
	options_context=get_node(_options_context_node)
	contents_model = get_node(contents_model_node)
	
	tab_container.connect("tree_item_tab_closed",self,"on_tab_closed")

	options_context.connect("id_pressed",self,"on_tree_item_option_selected")
	
	setup_tree_view();
	
	pass

func setup_tree_view():
	#load tree hierarachy form data-base
	var collections = list_contents_from_db("COLLECTION")
	var root = self.create_item(null,0)
	root.set_meta("type","root")
	self.hide_root = true
	load_nodes_recursive(collections,root)
	pass

func tree_item_selected():
	var item_data = get_selected().get_metadata(0)
	var item_path = get_selected().get_meta("path")
	var old_selected = get_selected()
	if item_data==null :
		return

	#create and manage tab for requests treeItem.
	if  item_data.has("url") :
		var hasSameTab =false
		var hasSameTabName =false
		for t in tab_container.get_children():
			if t.get_meta("path") == item_path:
				hasSameTab=true
				break
			
		for t in tab_container.get_children():
			if t.get_meta("name") == item_data.name:
				hasSameTabName=true
				break
			

		if !hasSameTab:
			var tabinstance = tabpanel.instance()
			var count = tab_container.get_tab_count()
			if hasSameTabName:
				tabinstance.set_name(item_path)
			else:
				tabinstance.set_name(item_data.name)
			tabinstance.set_meta("name",item_data.name)
			tabinstance.set_meta("path",item_path)
			
			tab_container.add_tab(tabinstance)
			
			tabinstance._set_request_data(item_data.method,item_data.name,item_data.url,item_data.options)
			old_selected.set_meta("index",tab_container.get_child_count())
		
		else:
			print(old_selected.get_meta("index"))
			tab_container.select_tab(old_selected.get_meta("index")-1)
	pass

func load_project_file(projectfile):

	if projectfile.speedpost_version:
		projectfile.project_name
	
		var root = self.create_item(null,0)
		root.set_meta("type","root")
		self.edit_selected()
		root.set_text(0,projectfile.project_name)
		for col in projectfile.collections:
			var collection= self.create_item(root)
			collection.set_meta("type","collection")
			collection.set_cell_mode(0,TreeItem.CELL_MODE_CUSTOM)
			collection.set_metadata(0,col)
			collection.set_text(0,col.name)
			for fold in col.folders:
				var folder= self.create_item(collection)
				folder.set_metadata(0,fold)
				folder.set_meta("type","folder")
				folder.set_cell_mode(0,TreeItem.CELL_MODE_CUSTOM)
				folder.set_text(0,fold.name)
				for req in fold.requests:
					var request = self.create_item(folder)
					request.set_cell_mode(0,TreeItem.CELL_MODE_STRING)

					request.set_editable(0,true)
					request.set_metadata(0,req)
					request.set_meta("type","request")
					request.set_meta("path",col.name+"-"+fold.name+"-"+req.name)
					request.set_text(0,req.name)
	else:
		return
	pass
	
func on_tree_item_left_click():
	var selected = get_selected()
	var data_id = selected.get_meta("data_id")
	var id = selected.get_meta("id")
	var type = selected.get_meta("type")
	var name = selected.get_meta("name")
	var tab_id = selected.get_meta("tab_id")
	var loaded_request_details = selected.get_meta("details")

	var query_string ="parent_id="+str(data_id)

	#creating new tab for selected tree item if has invalid tab_id 
	if tab_id<0:
		match type:
			"COLLECTION":
				loaded_request_details = $contents_table_view.details("id="+str(id))
				if loaded_request_details:
					selected.set_meta("details",JSON.parse(loaded_request_details.json_data))
					
			"FOLDER":
				loaded_request_details = $contents_table_view.details("id="+str(id))
				if loaded_request_details:
					selected.set_meta("details",JSON.parse(loaded_request_details.json_data))
					
			"REQUEST":
				loaded_request_details = $requests_table.details(query_string)
				selected.set_meta("details",loaded_request_details)
				#create new tab
				var tabinstance = tabpanel.instance()
				var count = tab_container.get_tab_count()
				tabinstance.set_name(name)
				tabinstance.set_meta("id",id)
				var new_tab_id = tab_container.add_tab(tabinstance)
				tabinstance.set_meta("tree_item",selected)
				selected.set_meta("tab_id",new_tab_id)
				tabinstance.update_request_data(loaded_request_details)
	else:
		tab_container.select_tab(tab_id)		
	print(loaded_request_details)	
	pass

func on_tree_item_right_click(vec):  
	var openable =false

	print(get_selected()," lol")
	match get_selected().get_meta("type"):
		"ROOT":
			openable=true
			options_context.set_item_disabled(0,false)
			options_context.set_item_disabled(1,false)
			options_context.set_item_disabled(2,false)
		"COLLECTION":
			openable=true
			options_context.set_item_disabled(0,true)
			options_context.set_item_disabled(1,false)
			options_context.set_item_disabled(2,false)
		"FOLDER":
			openable=true
			options_context.set_item_disabled(0,true)
			options_context.set_item_disabled(1,false)
			options_context.set_item_disabled(2,false)
		"REQUEST":
			openable=true
			options_context.set_item_disabled(0,true)
			options_context.set_item_disabled(1,true)
			options_context.set_item_disabled(2,true)

	if openable:
		vec.x+=10
		vec.y+=25
		options_context.popup()
		options_context.set_position(self.get_transform().xform(vec))
	pass

func on_tree_item_option_selected(index):
	var new_node_data =null
	match index:
		1:
			new_node_data =  insert_request_in_db({type="REQUEST",name="new request",parent_id=get_selected().get_meta("id")})
			add_new_tree_item(new_node_data,get_selected())
			
		2:
			new_node_data =  insert_folder_in_db({type="FOLDER",name="new folder",parent_id=get_selected().get_meta("id")})
			add_new_tree_item(new_node_data,get_selected())
			
		5:
			get_selected().get_parent().remove_child(get_selected())
			delete_item_from_db(get_selected().get_meta("id"),get_selected().get_meta("data_id"))

	self.update()
	pass

func on_tree_item_edited():
	var data_id = get_selected().get_meta("data_id")
	$node_data_table.update("id="+str(data_id),{"name":get_selected().get_text(0)})
	get_selected().set_meta("name",get_selected().get_text(0))
	pass

func on_tab_closed(tree_item):
	print("tab_closed on ", tree_item ,tree_item.get_meta("tab_id"))
	tree_item.set_meta("tab_id",-1)

func load_nodes_recursive(nodes_data,parent_node=null):

	var list = nodes_data.duplicate()
	print("load_nodes_recursive print")
	for n in list:
		#create ui node with n data
		var current_node = self.create_item(parent_node,0)
		if(n.name!=null):
			current_node.set_text(0,n.name)
			current_node.set_meta("name",n.name)
			current_node.set_meta("id",n.id)
			current_node.set_meta("type",n.type)
			current_node.set_meta("data_id",n.data_id)
			current_node.set_meta("tab_id",-1)
			current_node.set_tooltip(0,"id "+str(n.id)+" parent "+str(n.parent_id))
			current_node.set_editable(0,true)
			print("parent ",parent_node.get_meta("type") , parent_node ," child ",n.type , current_node)
			set_tree_item_icon(n.type,n.method,current_node)

			if n.type in ["FOLDER","COLLECTION"]:
				#load childs data from n.id
				var childs = contents_model.list("parent_id="+str(n.id))
				print(childs)
				load_nodes_recursive(childs,current_node);
	list.clear();
	pass

func add_new_tree_item(data,parent):
	
	var current_node= self.create_item(parent,0)
	current_node.set_text(0,data.name)
	current_node.set_meta("name",data.name)
	current_node.set_meta("type",data.type)
	current_node.set_meta("data_id",data.data_id)
	current_node.set_meta("tab_id",-1)
	current_node.select(0)
	current_node.set_editable(0,true)
	set_tree_item_icon(data.type,data.method,current_node)
	pass
	
func set_tree_item_icon(type,method,item):

	match type:
		"ROOT":
			item.set_icon(0,icons1.classic[type])
			item.set_icon_max_width(0,15)
		"COLLECTION":
			item.set_icon(0,icons1.classic[type])
			item.set_icon_max_width(0,15)
		"FOLDER":
			item.set_icon(0,icons1.classic[type])
			item.set_icon_max_width(0,15)
		"REQUEST":
	
			item.set_icon(0,icons1.classic[method])
			item.set_icon_max_width(0,25)
	pass
	
#Database calls.
#Item related db operation.
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

func insert_folder_in_db(data):

	print("Inserting request ",data)
	$nodes_table.create({"parent_id":str(data.parent_id)})
	var node_id =  $nodes_table.db.instance.last_insert_rowid
	$node_data_table.create({"parent_id":str(node_id),"name":data.name,"type":data.type})
	var inserted_request_node = $contents_table_view.details("id="+str(node_id))
	return inserted_request_node;
	pass

func delete_item_from_db(id,data_id,type="FOLDER"):
	match type:
		"FOLDER":
			print("deleting ",id)
			$node_data_table.delete("id="+str(data_id))
			return $nodes_table.delete("id="+str(id))
		"REQUEST":
			$requests_table.delete("parent_id="+str(data_id))
			$node_data_table.delete("id="+str(data_id))
			return $nodes_table.delete("id="+str(id))
	pass

func list_contents_from_db(type):
	return $contents_table_view.list("type='"+type+"'")

	
