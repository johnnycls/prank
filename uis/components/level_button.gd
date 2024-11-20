extends Button

func init(is_locked:bool, title:String, on_pressed: Callable):
	text = title
	
	if is_locked:
		disabled = true
		focus_mode = Control.FOCUS_NONE
		
	pressed.connect(on_pressed)
