extends Node2D

var goal_scene = preload("res://levels/0/goal.tscn")

@export var level_num = 0
@export var checkpoint_pos: Dictionary = {
	0: Vector2(16000,760),
}
@export var goal_position: Vector2 = Vector2(11000, 750)

@onready var player = $Player
@onready var player_cam = $PlayerFollowingCamera
@onready var whole_scene = $WholeScene

var init_game_state = {
	"checkpoint": 0,
}
var saved_game_state
var current_game_state

var goal

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
	Main.can_open_menu = true
	whole_scene.set_castle_scene("outside")
	get_tree().paused = true

func lose() -> void:
	_start()
	
func win() -> void:
	var new_game_state = {
		"cleared": true,
		"checkpoint": 0
	}
	Main.save_progress(new_game_state)
	Main.can_open_menu = false
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

func _on_player_dead() -> void:
	lose()

func _on_story_story_ended() -> void:
	$Story.queue_free()
	_start()

func _on_player_left_screen() -> void:
	lose()

func _on_whole_scene_castle_changed_scene(scene: String) -> void:
	if scene=="kitchen":
		goal = goal_scene.instantiate()
		goal.position = goal_position
		goal.player_enter.connect(win)
		add_child(goal)
	elif Global.is_node_valid(goal):
		goal.queue_free()
		goal = null
