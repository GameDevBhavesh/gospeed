extends Control


var following =false
var dragging_pos = Vector2()
func _on_Tobborder_gui_input(event):

	if event is InputEventMouseButton:
		if event.get_button_index()==1:
			following=!following
			dragging_pos = get_local_mouse_position();

	pass # Replace with function body.
	

func _process(delta):
	if(following):
		if OS.get_name()=="Windows":
			OS.window_position =(OS.window_position + get_local_mouse_position()-dragging_pos)
		
func _on_Button2_button_down():

	pass # Replace with function body.
	


func _on_Button2_button_up():
	if OS.get_name()=="Windows":
		if OS.is_window_minimized():
			OS.set_window_minimized(false)
		else:
			OS.set_window_minimized(true)

	print("minimizing..")
	pass # Replace with function body.


func _on_Button_button_up():
	get_tree().quit();
	pass # Replace with function body.
