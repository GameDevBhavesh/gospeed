extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var open_file_node: NodePath
export var open_folder_node: NodePath
export var project_view_node: NodePath

var _open_file_dialog: FileDialog
var project_view: Tree


# Called when the node enters the scene tree for the first time.
func _ready():
	project_view= get_node(project_view_node)
	_open_file_dialog = get_node(open_file_node)
	_open_file_dialog.connect("file_selected",self,"open_file")
	#_open_file_dialog.popup()
	pass # Replace with function body.


func open_file(path):
	var opener =  File.new()
	print(path)
	var selected_file =  opener.open(path,0)
	
	var file = File.new()
	file.open(path, File.READ)
	var save_dict = parse_json(file.get_as_text())
	print(save_dict.project_name)
	project_view.load_project_file(save_dict)
	pass # Replace with function body.
