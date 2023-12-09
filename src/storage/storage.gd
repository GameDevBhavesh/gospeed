extends Node
class_name db
	
const sql_lite = preload("res://addons/godot-sqlite/bin/gdsqlite.gdns")
var db_name:="speedpost"
var db_path := "res://data/"
 
var instance

func _init():
	instance = sql_lite.new()
	instance.path = db_path+db_name
	instance.open_db()
	
func _ready():
	var test_table = instance.query("CREATE TABLE test (id INTEGER PRIMARY KEY AUTOINCREMENT,parent_id INTEGER DEFAULT ( -1) );")
	var nodes_table = instance.query("CREATE TABLE nodes IF NOT EXISTS (id INTEGER PRIMARY KEY AUTOINCREMENT,parent_id INTEGER DEFAULT ( -1) );")
	var node_data_table = instance.query("CREATE TABLE node_data IF NOT EXISTS (id INTEGER PRIMARY KEY AUTOINCREMENT,parent_id VARCHAR,json_data VARCHAR DEFAULT ('{}'),name      VARCHAR DEFAULT new,type      VARCHAR DEFAULT folder);")
	var requests_table = instance.query("CREATE TABLE node_data IF NOT EXISTS (id INTEGER PRIMARY KEY AUTOINCREMENT,parent_id VARCHAR,json_data VARCHAR DEFAULT ('{}'),name      VARCHAR DEFAULT new,type      VARCHAR DEFAULT folder);")
	print(test_table,nodes_table,node_data_table,requests_table)
