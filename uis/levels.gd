extends MarginContainer

var home_ui = load("res://uis/home.tscn")
var level_btn_scene = preload("res://uis/components/level_button.tscn")

@onready var back_btn = $ScrollContainer/VBoxContainer/BackBtn
@onready var button_container = $ScrollContainer/VBoxContainer

var UNLOCK_CRITERIA = {
	0: true,
	1: Main.progress.get("0", {}).get("cleared", false)
}
var buttons: Array = []
var last_unlocked_button

func _ready():
	create_level_buttons()
	Main.ui_changed.connect(init)

func init():
	last_unlocked_button.grab_focus()

func create_level_button(level_number: int):
	var is_locked = not UNLOCK_CRITERIA[level_number]
	# var status = Main.progress.get(str(level_number), {})
	var title = "TITLE_%d" % level_number
	
	var level_btn = level_btn_scene.instantiate()
	level_btn.init(is_locked, title, func(): start_level(level_number))
	
	if not is_locked:
		last_unlocked_button = level_btn
	return level_btn

func create_level_buttons():	
	for i in range(Config.LEVELS):
		var button = create_level_button(i)
		button_container.add_child(button)
		buttons.append(button)

func start_level(level: int)-> void:
	Main.start_level(level)

func _on_back_btn_pressed() -> void:
	Main.change_ui(home_ui.instantiate())
