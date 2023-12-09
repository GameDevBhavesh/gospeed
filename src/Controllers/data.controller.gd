extends Node
class_name DataController

onready var nodes = get_node("/root/NodesService")
onready var node_data = get_node("/root/NodeDataService")
onready var requests = get_node("/root/RequestsService")
onready var contents = get_node("/root/ContentsService")



func save_request(id:String,name:String,url:String,type:String,data:Dictionary):
	if id !="":
		requests.update_data("id="+str(id),data)
		return id
	else:
		nodes.create_data(({"parent_id":str(data.parent_id)}))
		var node_id =  nodes.db.instance.last_insert_rowid
		node_data.create_data({"parent_id":str(node_id),"name":data.name,"type":type})
		var node_data_id =  node_data.db.instance.last_insert_rowid
		requests.create_data({"parent_id":str(node_data_id)})
		return contents.details_data("id="+str(node_id))
		 
	pass

func save_node(id:String,parent_id:String):
	if id !="":
		nodes.update_data("id="+str(id),{"parent_id":parent_id})
		return contents.details_data("id="+id)
		return 
	else:
		nodes.create_data(({"parent_id":parent_id}))
		var node_id =  nodes.db.instance.last_insert_rowid
		return contents.details_data("id="+str(node_id))
	pass

func delete_node(id:String,type:String,soft=true):
#TODO: handle case for non soft delete.
	match type:
		"COLLECTION":
			return nodes.update_data("id="+str(id),{"state":"DELETED"})
		"FOLDER":
			return nodes.update_data("id="+str(id),{"state":"DELETED"})
		"REQUEST":
			return nodes.update_data("id="+str(id),{"state":"DELETED"})


func delete_node_data(id:String,data:Dictionary):
	if id !="":
		requests.update_data("id="+str(id),data)
		return id
	else:
		nodes.create_data(({"parent_id":str(data.parent_id)}))
		var node_id =  nodes.db.instance.last_insert_rowid
		node_data.create_data({"parent_id":str(node_id),"name":data.name,"type":data.type})
		var node_data_id =  node_data.db.instance.last_insert_rowid
		requests.create_data({"parent_id":str(node_data_id)})
		contents.details_data("id="+str(node_id))
		return requests.db.instance.last_insert_rowid
	pass

func import_database(id:String,data:Dictionary):
	if id !="":
		requests.update_data("id="+str(id),data)
		return id
	else:
		nodes.create_data(({"parent_id":str(data.parent_id)}))
		var node_id =  nodes.db.instance.last_insert_rowid
		node_data.create_data({"parent_id":str(node_id),"name":data.name,"type":data.type})
		var node_data_id =  node_data.db.instance.last_insert_rowid
		requests.create_data({"parent_id":str(node_data_id)})
		contents.details_data("id="+str(node_id))
		return requests.db.instance.last_insert_rowid
	pass

func import_postman_database(id:String,data:Dictionary):
	if id !="":
		requests.update_data("id="+str(id),data)
		return id
	else:
		nodes.create_data(({"parent_id":str(data.parent_id)}))
		var node_id =  nodes.db.instance.last_insert_rowid
		node_data.create_data({"parent_id":str(node_id),"name":data.name,"type":data.type})
		var node_data_id =  node_data.db.instance.last_insert_rowid
		requests.create_data({"parent_id":str(node_data_id)})
		contents.details_data("id="+str(node_id))
		return requests.db.instance.last_insert_rowid
	pass
