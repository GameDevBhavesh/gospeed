extends Node
class_name Contents

onready var db =get_node("/root/Db")

func list(where:String):
	var data: Array = db.instance.select_rows("contents",where,["*"])
	print(where+" ",data)
	return data
	pass

func details(where:String):
	var data: Array = db.instance.select_rows("contents",where,["*"])
	print(where+" ",data)
	return data[0]
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
