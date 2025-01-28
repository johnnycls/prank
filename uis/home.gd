extends VBoxContainer

@onready var story_btn: Button = $StoryBtn

var levels_scene = load("res://uis/levels.tscn")
var settings_scene = load("res://uis/settings.tscn")

func _ready() -> void:
	Main.ui_changed.connect(init)
	init()

func init():
	story_btn.grab_focus()

func _on_settings_btn_pressed() -> void:
	Main.change_ui(settings_scene.instantiate())

func _on_story_btn_pressed() -> void:
	Main.change_ui(levels_scene.instantiate())

func _on_endless_btn_pressed() -> void:
	Main.start_level(-1)

func _on_exit_btn_pressed() -> void:
	get_tree().quit()
