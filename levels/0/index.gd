extends Node2D

@export var level_num = 0
@export var checkpoint_pos: Dictionary = {
	0: Vector2(0,0),
}

@onready var player = $Player

var init_game_state = {
	"checkpoint": 0,
}
var saved_game_state
var current_game_state

func _start() -> void:
	current_game_state = init_game_state.duplicate(true)
	player.position = checkpoint_pos[int(init_game_state.get("checkpoint", 0))]

func _ready() -> void:
	if Main.progress.has(level_num):
		saved_game_state = Main.progress[level_num]
		init_game_state.checkpoint = saved_game_state.checkpoint
	else:
		saved_game_state = init_game_state.duplicate(true)			
	_start()

func lose() -> void:
	_start()
	
func win() -> void:
	var new_game_state = {
		"run": true,
		"checkpoint": 0
	}
	Main.win_level(new_game_state)

func get_checkpoint(checkpoint: int) -> void:
	var new_game_state = {
		"run": saved_game_state.get("run", false),
		"checkpoint": checkpoint
	}
	init_game_state = {
		"checkpoint": checkpoint
	}
	Main.save_checkpoint(new_game_state)

func _on_player_dead() -> void:
	lose()
