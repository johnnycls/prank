extends VBoxContainer

@onready var back_btn = $Btns/BackBtn
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_menu"):
		if visible:
			close_menu()
		elif (Main.can_open_menu):
			open_menu()

func close_menu() -> void:
	hide()
	get_tree().paused = false

func open_menu() -> void:
	get_tree().paused = true
	show()
	back_btn.grab_focus()

func _on_back_btn_pressed() -> void:
	close_menu()
	
func _on_home_screen_btn_pressed() -> void:
	Main.back_to_home_screen()
	close_menu()
