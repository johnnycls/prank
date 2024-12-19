extends CanvasLayer

@onready var ui: Control = $UI
@onready var menu: Control = $Menu
@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer

func _ready() -> void:
	add_sound_effects_for_btns(ui)
	add_sound_effects_for_btns(menu)
	
func clear_ui() -> void:
	for n in ui.get_children():
		n.queue_free()

func change_ui(page: Control) -> void:
	clear_ui()
	ui.add_child(page)
	add_sound_effects_for_btns(page)

func open_menu() -> void:
	menu.open_menu()
	
func close_menu() -> void:
	menu.close_menu()

func add_sound_effects_for_btns(node: Node) -> void:
	if node is Button:
		node.focus_entered.connect(audio_player.select)
		node.pressed.connect(audio_player.select)
	for child in node.get_children():
		add_sound_effects_for_btns(child)
