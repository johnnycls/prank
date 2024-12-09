extends Node2D

var ui = preload("res://levels/-1/ui.tscn").instantiate()

@onready var player = $Player
@onready var runway = $Runway

@export var level_num: int
@export var init_position: Vector2

var init_game_state = {
	"distance": 0,
}
var saved_game_state
var current_game_state

func current_distance() -> float:
	return player.global_position.x + runway.current_revolution*runway.total_length if player else 0.0

func _start() -> void:
	current_game_state = init_game_state.duplicate(true)
	runway.init()	
	player.global_position = init_position
	player.init()

func _ready() -> void:
	if Main.progress.has(str(level_num)):
		saved_game_state = Main.progress[str(level_num)]
	else:
		saved_game_state = init_game_state.duplicate(true)
	Main.change_ui(ui)
	_start()
	
func _process(_delta: float) -> void:
	current_game_state.distance = current_distance()
	ui.set_distance(current_distance())

func lose() -> void:
	_start()

func _on_player_area_or_body_entered(area_or_body: Node2D) -> void:
	if area_or_body.is_in_group("killzone"):
		player.hit(area_or_body.damage)
	if area_or_body.is_in_group("remove_when_touched_by_player"):
		area_or_body.queue_free()

func _on_player_dead() -> void:
	lose()

func _on_player_left_screen() -> void:
	lose()
