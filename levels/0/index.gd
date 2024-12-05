extends Node2D

var story_scene = preload("res://levels/0/story.tscn")

@export var level_num = 1
@export var checkpoint_pos: Dictionary = {
	0: Vector2(0,0),
}

@onready var camera = $Camera
@onready var player = $Player
@onready var player_cam = $PlayerFollowingCamera

var init_game_state = {
	"checkpoint": 0,
}
var saved_game_state
var current_game_state

func _start() -> void:
	player_cam.enabled = false
	current_game_state = init_game_state.duplicate(true)
	player.position = checkpoint_pos[int(init_game_state.get("checkpoint", 0))]
	player.init()
	player.process_mode = Node.PROCESS_MODE_DISABLED
	camera.enabled = true
	camera.move_to_player()

func _ready() -> void:
	if Main.progress.has(str(level_num)):
		saved_game_state = Main.progress[str(level_num)]
		init_game_state.checkpoint = saved_game_state.checkpoint
	else:
		saved_game_state = init_game_state.duplicate(true)
	Main.story_ended.connect(_on_story_ended)
	Main.start_story(story_scene.instantiate())

func lose() -> void:
	_start()
	
func win() -> void:
	var new_game_state = {
		"cleared": true,
		"checkpoint": 0
	}
	Main.win_level(new_game_state)

func get_checkpoint(checkpoint: int) -> void:
	var new_game_state = {
		"cleared": saved_game_state.get("cleared", false),
		"checkpoint": checkpoint
	}
	init_game_state = {
		"checkpoint": checkpoint
	}
	Main.save_checkpoint(new_game_state)

func _on_player_area_or_body_entered(area_or_body: Node2D) -> void:
	if area_or_body.is_in_group("killzone"):
		player.hit(area_or_body.damage)

func _on_enemy_died() -> void:
	win()

func _on_player_die() -> void:
	lose()

func _on_camera_camera_transition_complete() -> void:
	camera.enabled = false
	player.process_mode = Node.PROCESS_MODE_INHERIT
	player_cam.enabled = true

func _on_goal_player_enter() -> void:
	win()

func _on_story_ended():
	_start()
