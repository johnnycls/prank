extends Node

const PROGRESS_PATH = "user://progress.save"
const PREFERENCE_PATH = "user://preference.save"

const LANGS = {"cmn": "简体中文", "en": "English", "zh": "繁體中文"}
const DEFAULT_LANG = "en"

const LEVELS = 2

func level_to_path(level: int) -> String:
	return "res://levels/" + str(level) + "/index.tscn"
