extends Control

var url = null
var method = null

var child

func _ready():
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_RequestButton_pressed():
	url = $Panel/VSplitContainer/HSplitContainer/main/VBoxContainer/Panel/HBoxContainer/RequestURL.text
	method = $Panel/VSplitContainer/HSplitContainer/main/VBoxContainer/Panel/HBoxContainer/RequestType.text	
	send_request()
	pass
 

func send_request():
	print("button pressed: ", url)
	print("Method: ", method)
	pass




func _on_more_button_up():
	pass # Replace with function body.
