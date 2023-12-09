extends Control

# Declare member variables here. Examples:
# var a = 2
var _request:HTTPRequest;


export var _request_url_node:NodePath
var _request_url_text:LineEdit 

export var _requested_info_url_node:NodePath
var _requested_info_url:LineEdit 

export var _request_method_node:NodePath
onready var _request_method:OptionButton 

export var _request_body_node:NodePath
onready var _request_body:TextEdit 

export var _request_headers_node:NodePath
onready var _request_headers:VBoxEditableList 

export var _request_params_node:NodePath
onready var _request_params:VBoxEditableList 

export var _request_response_node:NodePath
onready var _request_response:TextEdit 

export var _request_button_node:NodePath
onready var _request_button:BaseButton 


export var _res_beautfy_button_node:NodePath
onready var _res_beautfy_button:BaseButton 

export var _req_beautify_button_node:NodePath
onready var _req_beautify_button:BaseButton 


# Called when the node enters the scene tree for the first time.
func _enter_tree ():
	print("added new tab")
	_request = $HTTPRequest
	_request_url_text =get_node(_request_url_node)
	_request_method =get_node(_request_method_node)
	_request_body =get_node(_request_body_node)
	_request_headers = get_node(_request_headers_node)
	_request_params= get_node(_request_params_node)
	_request_response =get_node(_request_response_node)
	_request_button = get_node(_request_button_node)
	_requested_info_url =get_node(_requested_info_url_node)
	_req_beautify_button= get_node(_req_beautify_button_node)
	_res_beautfy_button= get_node(_res_beautfy_button_node)
	_request_button.connect("button_up",self,"_request_current")
	_res_beautfy_button.connect("button_down",self,"_beautify_res")
	_req_beautify_button.connect("button_down",self,"_beautify_body")
	
	
	pass 
	
func _beautify_res():
	_request_response.text=JSONBeautifier.beautify_json(_request_response.text) 
	pass
	
func _beautify_body():
	_request_body.text=JSONBeautifier.beautify_json(_request_body.text) 
	pass
func _request_current():
	var body = to_json(parse_json( _request_body.text)) 
	_request_response.text="Requesting..."
	var headers=_request_headers.get_keyvalue_items()
	var final_url = _request_url_text.text+"?"
	for p in _request_params.get_keyvalue_items():
		print(final_url.find_last("&"))
		if final_url.find_last("&")!=final_url.length()-1:
			final_url+="&"+p.replace(":","=")
		else:
			final_url+=p.replace(":","=")
	final_url= final_url.replace("?&","?")
	_requested_info_url.text ="Requested Url : " + final_url
	print("requested to "+_request_method.get_item_text(_request_method.selected)+" "+final_url +" body "+body+" headers ")
	
	_request.request(final_url,headers,false,_request_method.get_item_id(_request_method.selected),body)
	_request.connect("request_completed",self,"_on_request_completed")

	pass

func _on_request_completed(result, response_code, headers, body):
	print((body as PoolByteArray).get_string_from_utf8())
	var resstr =(body as PoolByteArray).get_string_from_utf8()
	_request_response.text =resstr
	#$Panel/VSplitContainer/ResponsePanel/VBoxContainer/Information/status.text= "Status "+str(response_code)
	#$Panel/VSplitContainer/ResponsePanel/VBoxContainer/Information/size.text= "Size "+str(_request_response.text.length())
	_request.disconnect("request_completed",self,"_on_request_completed")
	pass 

func _set_request_data(method,name,url,options):
	_request_method.select(method)
	_request_url_text.text =url
	_request_body.text =to_json(options.body) 
	_request_headers.set_keyvalue_items_from_dict(options.headers)
	_request_params.set_keyvalue_items_from_dict(options.params)
	pass

func update_request_data(data):
	
	_request_method.select(http_method_to_int(data.method))
	_request_url_text.text =data.url
	_request_body.text =to_json(data.body)
	#_request_headers.set_keyvalue_items_from_dict(data.headers)
	#_request_params.set_keyvalue_items_from_dict(data.params)
	pass
	
func http_method_to_int(method):
	match method:
		"GET":return 0
		"HEAD":return 1
		"POST":return 2
		"PUT":return 3
		"DELETE":return 4
	return
	pass
