extends Node2D

@export var level_num = 0
@export var checkpoint_pos: Dictionary = {
	0: Vector2(16000,760),
}

@onready var player = $Player
@onready var player_cam = $PlayerFollowingCamera
@onready var story = $Story

var init_game_state = {
	"checkpoint": 0,
}
var saved_game_state
var current_game_state

func _start() -> void:
	current_game_state = init_game_state.duplicate(true)
	player.global_position = checkpoint_pos[int(init_game_state.get("checkpoint", 0))]
	player_cam.global_position.x = player.global_position.x
	player.init()
	player_cam.enabled = true

func _ready() -> void:
	if Main.progress.has(str(level_num)):
		saved_game_state = Main.progress[str(level_num)]
		init_game_state.checkpoint = saved_game_state.checkpoint
	else:
		saved_game_state = init_game_state.duplicate(true)

func lose() -> void:
	_start()
	
func win() -> void:
	var new_game_state = {
		"cleared": true,
		"checkpoint": 0
	}
	Main.save_progress(new_game_state)
	Main.end_level()

func get_checkpoint(checkpoint: int) -> void:
	var new_game_state = {
		"cleared": saved_game_state.get("cleared", false),
		"checkpoint": checkpoint
	}
	init_game_state = {
		"checkpoint": checkpoint
	}
	Main.save_progress(new_game_state)

func _on_player_area_or_body_entered(area_or_body: Node2D) -> void:
	if area_or_body.is_in_group("killzone"):
		player.hit(area_or_body.damage)

func _on_player_dead() -> void:
	lose()

func _on_goal_player_enter() -> void:
	win()

func _on_story_story_ended() -> void:
	story.queue_free()
	_start()
