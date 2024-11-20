extends Node

signal ui_changed

var home_scene = load("res://uis/home.tscn")
var levels_ui = load("res://uis/levels.tscn")

var _current_scene: Node
var current_level: int
var progress: Dictionary
var can_open_menu: bool = false

func _ready() -> void:
	# $State.delete_progress()
	progress = $State.read_progress()
	
func _remove_scene() -> void:
	if _current_scene:
		_current_scene.queue_free()
		_current_scene = null
	
func start_level(level: int) -> void:
	_remove_scene()
	$Hud.clear_ui()
	_current_scene = load(Config.level_to_path(level)).instantiate()
	add_child(_current_scene)
	current_level = level
	can_open_menu = true

func back_to_home_screen() -> void:
	_remove_scene()
	change_ui(home_scene.instantiate())
	can_open_menu = false

func change_ui(page: Control) -> void:
	$Hud.change_ui(page)
	ui_changed.emit()
	
func win_level(level_status) -> void:
	_update_progress(current_level, level_status)
	var timer = get_tree().create_timer(2.0)
	await timer.timeout
	_remove_scene()
	change_ui(levels_ui.instantiate())
	
func save_checkpoint(level_status) -> void:
	_update_progress(current_level, level_status)

func _update_progress(key, value)-> void:	
	progress[key] = value
	$State.save_progress(progress)
