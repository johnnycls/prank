extends Node

var INIT_PROGRESS: Dictionary = {}

func read_progress() -> Dictionary:
	if not FileAccess.file_exists(Config.PROGRESS_PATH):
		return INIT_PROGRESS
	
	var file = FileAccess.open(Config.PROGRESS_PATH, FileAccess.READ)
	if not file:
		return INIT_PROGRESS
	
	var json = JSON.new()
	return json.get_data() if json.parse(file.get_as_text()) == OK else INIT_PROGRESS

func save_progress(_progress: Array) -> bool:
	var file = FileAccess.open(Config.PROGRESS_PATH, FileAccess.WRITE)
	if not file:
		return false
	
	file.store_string(JSON.stringify(_progress))
	file.close()
	return true

func delete_progress() -> bool:
	if FileAccess.file_exists(Config.PROGRESS_PATH):
		return DirAccess.remove_absolute(Config.PROGRESS_PATH) == OK
	return true
