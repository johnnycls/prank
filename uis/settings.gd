extends Control

const home := preload("res://uis/home.tscn")

@onready var back_btn: Button = $BackBtn
@onready var lang_select: OptionButton = $LangSelect

func init() -> void:
	lang_select.grab_focus()

func _ready() -> void:
	Main.ui_changed.connect(init)
	
	back_btn.pressed.connect(_on_back_button_pressed)
	lang_select.item_selected.connect(_on_language_selected)
	
	for lang_id in Config.LANG_IDS.keys():
		lang_select.add_item(Config.LANG_NAMES[Config.LANG_IDS[lang_id]], lang_id)
	load_settings()

func _on_back_button_pressed() -> void:
	save_settings()
	Main.change_ui(home.instantiate())
	
func _on_language_selected(id: int) -> void:
	var code: String = Config.LANG_IDS[id]
	TranslationServer.set_locale(code)

func save_settings() -> void:
	var settings: Dictionary = {
		"language": lang_select.selected
	}
	var file: FileAccess = FileAccess.open(Config.PREFERENCE_PATH, FileAccess.WRITE)
	file.store_var(settings)
	file.close()

func load_settings() -> void:	
	var lang_id: int = Config.DEFAULT_LANG
	if FileAccess.file_exists(Config.PREFERENCE_PATH):
		var file: FileAccess = FileAccess.open(Config.PREFERENCE_PATH, FileAccess.READ)
		var settings: Dictionary = file.get_var()
		file.close()
		lang_id = settings.get("language", Config.DEFAULT_LANG)
	lang_select.selected = lang_id
	TranslationServer.set_locale(Config.LANG_IDS[lang_id])
