extends Node
class_name Service

export var tablename:String

onready var db = get_node("/root/DbSingleton")

#var connection =  sql_lite.new()

func create_data(update:Dictionary):
	var data: bool = db.instance.insert_row(tablename,update)
	#print(update ,data)
	return data
	pass
	
func list_data(where:String):
	var data: Array = db.instance.select_rows(tablename,where,["*"])
	return data
	pass

func details_data(where:String):
	var data: Array = db.instance.select_rows(tablename,where,["*"])
	
	#print(where+" ",data)
	if data.size()>0:
		return data[0]
	else:
		return null
	pass

func update_data(where:String,update:Dictionary):
	var data: bool = db.instance.update_rows(tablename,where,update)
	#print(where+" ",data)
	return data
	pass

func delete_data(where:String):
	var data: bool = db.instance.delete_rows(tablename,where)
	#print(where+" ",data)
	return data
	pass
	
