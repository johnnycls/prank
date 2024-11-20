extends Control

const home := preload("res://uis/home.tscn")

@onready var back_btn: Button = $BackBtn
@onready var lang_select: OptionButton = $LangSelect

var lang_id_to_code: Dictionary = {}

func init() -> void:
	lang_select.grab_focus()

func _ready() -> void:
	Main.ui_changed.connect(init)
	
	back_btn.pressed.connect(_on_back_button_pressed)
	lang_select.item_selected.connect(_on_language_selected)
	
	var id: int = 0
	for code in Config.LANGS.keys():
		lang_select.add_item(Config.LANGS[code], id)
		lang_id_to_code[id] = code
		id += 1
	load_settings()

func _on_back_button_pressed() -> void:
	save_settings()
	Main.change_ui(home.instantiate())
	
func _on_language_selected(id: int) -> void:
	var code: String = lang_id_to_code[id]
	TranslationServer.set_locale(code)

func save_settings() -> void:
	var settings: Dictionary = {
		"language": lang_select.selected
	}
	var file: FileAccess = FileAccess.open(Config.PREFERENCE_PATH, FileAccess.WRITE)
	file.store_var(settings)
	file.close()

func load_settings() -> void:
	if FileAccess.file_exists(Config.PREFERENCE_PATH):
		var file: FileAccess = FileAccess.open(Config.PREFERENCE_PATH, FileAccess.READ)
		var settings: Dictionary = file.get_var()
		file.close()
		var lang_id: int = settings.get("language", 0)
		lang_select.selected = lang_id
		TranslationServer.set_locale(lang_id_to_code[lang_id])
	else:
		for id in lang_id_to_code.keys():
			if lang_id_to_code[id] == Config.DEFAULT_LANG:
				lang_select.selected = id
				break
		TranslationServer.set_locale(Config.DEFAULT_LANG)
