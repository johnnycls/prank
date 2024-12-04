extends Node2D

var ui = preload("res://levels/1/ui.tscn").instantiate()

@onready var player = $Player
@onready var runway = $Runway

@export var level_num: int = -1
@export var init_position: Vector2

var init_game_state = {
	"distance": 0,
}
var saved_game_state
var current_game_state

func _start() -> void:
	current_game_state = init_game_state.duplicate(true)
	player.position = init_position
	player.init()

func _ready() -> void:
	if Main.progress.has(str(level_num)):
		saved_game_state = Main.progress[str(level_num)]
	else:
		saved_game_state = init_game_state.duplicate(true)
	Main.change_ui(ui)
	_start()
	
func _process(_delta: float) -> void:
	current_game_state.distance = player.global_position.x + runway.current_revolution*runway.total_length
	ui.set_distance(current_game_state.distance)

func lose() -> void:
	_start()
	
func win() -> void:
	var new_game_state = {
		"distance": max(saved_game_state.distance, current_game_state.distance)
	}
	Main.win_level(new_game_state)

func _on_player_area_or_body_entered(area_or_body: Node2D) -> void:
	if area_or_body.is_in_group("killzone"):
		player.hit(area_or_body.damage)

func _on_player_die() -> void:
	lose()
