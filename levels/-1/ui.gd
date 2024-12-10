extends Control

signal start

@onready var play_ui = $PlayUI
@onready var start_menu = $StartMenu
@onready var lose_menu = $LoseMenu
@onready var distance_label = $PlayUI/Label
@onready var start_menu_highest_score_label = $StartMenu/HighestScoreLabel
@onready var start_btn = $StartMenu/StartBtn
@onready var lose_menu_highest_score_label = $LoseMenu/HighestScoreLabel
@onready var record_breaking_label = $LoseMenu/RecordBreakingLabel
@onready var again_btn = $LoseMenu/AgainBtn

func set_distance(distance: float) -> void:
	distance_label.text = str(int(distance))
	
func init(highest_score: int) -> void:
	start_menu_highest_score_label.text = tr("HIGHEST_SCORE_%d" % highest_score)
	start_btn.grab_focus()

func play() -> void:
	play_ui.show()
	start_menu.hide()
	lose_menu.hide()
	
func lose(is_record_breaking: bool, highest_score: int) -> void:
	play_ui.hide()
	start_menu.hide()
	lose_menu.show()
	if is_record_breaking:
		record_breaking_label.show()
	else:
		record_breaking_label.hide()
	lose_menu_highest_score_label.text = tr("HIGHEST_SCORE_%d" % highest_score)
	again_btn.grab_focus()

func _on_start_btn_pressed() -> void:
	get_tree().paused = false
	start.emit()

func _on_again_btn_pressed() -> void:
	get_tree().paused = false
	start.emit()

func _on_back_btn_pressed() -> void:
	get_tree().paused = false
	Main.back_to_home_screen()
