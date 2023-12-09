extends Node
class_name RequestsTable

export var tablename:String

onready var storage = get_node("/root/storage")

func create(update:Dictionary):
	var data: bool = storage.instance.insert_row(tablename,update)
	#print(update ,data)
	return data
	pass
	
func list(where:String):
	var data: Array = storage.instance.select_rows(tablename,where,["*"])
	return data
	pass

func details(where:String):
	var data: Array = storage.instance.select_rows(tablename,where,["*"])
	
	#print(where+" ",data)
	if data.size()>0:
		return data[0]
	else:
		return null
	pass

func update(where:String,update:Dictionary):
	var data: bool = storage.instance.update_rows(tablename,where,update)
	#print(where+" ",data)
	return data
	pass

func delete(where:String):
	var data: bool = storage.instance.delete_rows(tablename,where)
	#print(where+" ",data)
	return data
	pass
	
