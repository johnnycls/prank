extends CanvasLayer

@onready var ui: Control = $UI
	
func clear_ui() -> void:
	for n in ui.get_children():
		n.queue_free()

func change_ui(page: Control) -> void:
	clear_ui()
	ui.add_child(page)
