extends Node2D

var ui = preload("res://levels/-1/ui.tscn").instantiate()

@onready var player = $Player
@onready var runway = $Runway
@onready var cam = $PlayerFollowingCamera
@onready var background = $Background
@onready var bird_audio = $BirdAudio

@export var level_num: int
@export var init_position: Vector2

var init_game_state: Dictionary = {
	"distance": 0,
}
var saved_game_state: Dictionary
var current_game_state: Dictionary

var is_playing: bool = false

func current_distance() -> float:
	return player.global_position.x + runway.current_revolution*runway.total_length if Global.is_node_valid(player) else 0.0

func get_cam_distance() -> float:
	return cam.global_position.x + runway.current_revolution*runway.total_length if Global.is_node_valid(player) else 0.0

func _start() -> void:
	current_game_state = init_game_state.duplicate(true)
	runway.init()	
	player.global_position = init_position
	player.init()
	ui.play()
	is_playing = true
	bird_audio.play()
	Main.play_bgm(1,0)
	Main.can_open_menu = true

func _ready() -> void:
	if Main.progress.has(str(level_num)):
		saved_game_state = Main.progress[str(level_num)]
	else:
		saved_game_state = init_game_state.duplicate(true)
	Main.change_ui(ui)
	ui.start.connect(_start)
	ui.init(int(saved_game_state.distance))
	Main.can_open_menu = false
	get_tree().paused = true
	
func _process(_delta: float) -> void:
	if is_playing:
		current_game_state.distance = current_distance()
		background.set_offset_by_distance(get_cam_distance())
		ui.set_distance(current_game_state.distance)

func lose() -> void:
	is_playing = false
	Main.can_open_menu = false
	for node in Global.get_valid_nodes_in_group("moving_objects"):
		node.queue_free()
	var is_record_breaking = current_game_state.distance > saved_game_state.distance
	if is_record_breaking:
		saved_game_state = current_game_state
		Main.save_progress(saved_game_state)
	ui.lose(is_record_breaking, int(saved_game_state.distance))
	bird_audio.stop()
	Main.stop_bgm(0.0)
	get_tree().paused = true

func _on_player_dead() -> void:
	lose()

func _on_player_left_screen() -> void:
	lose()
