extends Control

@onready var levels_btn: Button = $LevelsBtn
@onready var setttings_btn: Button = $SettingsBtn

var levels_scene = load("res://uis/levels.tscn")
var settings_scene = load("res://uis/settings.tscn")

func _ready() -> void:
	Main.ui_changed.connect(init)
	init()

func init():
	levels_btn.grab_focus()

func _on_levels_btn_pressed() -> void:
	Main.change_ui(levels_scene.instantiate())

func _on_settings_btn_pressed() -> void:
	Main.change_ui(settings_scene.instantiate())
