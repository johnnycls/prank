extends Node

const PROGRESS_PATH = "user://progress.save"
const PREFERENCE_PATH = "user://preference.save"

const LANG_IDS: Dictionary = {0: "cmn", 1: "en", 2: "zh"}
const LANG_NAMES = {"cmn": "简体中文", "en": "English", "zh": "繁體中文"}
const DEFAULT_LANG = 1

const LEVELS = 8

func level_to_path(level: int) -> String:
	return "res://levels/" + str(level) + "/index.tscn"
