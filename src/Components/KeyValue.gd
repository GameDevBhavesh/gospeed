extends HBoxContainer
class_name KeyValueInput

# Declare member variables here. Examples:
var pair ={
	key="",
	value=""
}
var me = load("res://Scene/KeyValue.tscn")
func _ready():
	$close.connect("button_down",self,"_on_close")
	$add.connect("button_down",self,"_on_add")
	pair.key=$name.text
	pair.value=$value.text
	pass
	
func _on_close():
	queue_free()
	pass
	
	
func _on_add():
	var temins = me.instance()
	get_parent().add_child(temins)
	pass
	

# Called when the node enters the scene tree for the first time.
func _setpair(_pair):
	pair.key =_pair.key
	pair.value =_pair.value
	$name.text=pair.key
	$value.text=pair.value
	pass # Replace with function body.
func _get_pair():
	return pair
	pass
func _get_json_pair():
	pair.key=$name.text
	pair.value=$value.text
	return pair
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
