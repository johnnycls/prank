extends Node2D

var goal_scene = preload("res://levels/0/goal.tscn")

@export var level_num = 1
@export var checkpoint_pos: Dictionary = {
	0: Vector2(22800, 735),
}

@onready var player = $Player
@onready var warrior = $Warrior
@onready var player_cam = $PlayerFollowingCamera
@onready var whole_scene = $WholeScene
@onready var spawn_bird = $SpawnBird
@onready var bird_audio = $BirdAudio

var init_game_state = {
	"checkpoint": 0,
}
var saved_game_state
var current_game_state

var goal

func _physics_process(_delta: float) -> void:
	if player and player.global_position.x > 47000:
		player.queue_free()
		for node in Global.get_valid_nodes_in_group("killzone"):
			node.queue_free()
		spawn_bird.queue_free()
		bird_audio.queue_free()
		get_tree().paused = true
		$Story.next_step()

func _start() -> void:
	player.show()
	warrior.show()
	current_game_state = init_game_state.duplicate(true)
	player.global_position = checkpoint_pos[int(init_game_state.get("checkpoint", 0))]
	warrior.global_position.x = player.global_position.x - 1000
	player_cam.global_position.x = player.global_position.x
	player.init()
	player_cam.enabled = true
	whole_scene.player_following_cam = player_cam

func _ready() -> void:
	if Main.progress.has(str(level_num)):
		saved_game_state = Main.progress[str(level_num)]
		init_game_state.checkpoint = saved_game_state.checkpoint
	else:
		saved_game_state = init_game_state.duplicate(true)
	Main.can_open_menu = true
	whole_scene.set_castle_scene("room")
	get_tree().paused = true
	$Story.next_step()

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

func _on_story_story_ended(times: int) -> void:
	if times==0:
		get_tree().paused = false
		$Story.hide()
		_start()
	else:
		win()

func _on_player_left_screen() -> void:
	lose()
