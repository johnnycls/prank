extends Node2D

@export var level_num = 2
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

func _start() -> void:
	current_game_state = init_game_state.duplicate(true)
	player.global_position = checkpoint_pos[int(init_game_state.get("checkpoint", 0))]
	warrior.global_position.x = player.global_position.x - 1000
	player_cam.global_position.x = player.global_position.x
	player.init()
	player.show()
	warrior.show()
	player_cam.enabled = true
	whole_scene.init(player_cam)

func _ready() -> void:
	if Main.progress.has(str(level_num)):
		saved_game_state = Main.progress[str(level_num)]
		init_game_state.checkpoint = saved_game_state.checkpoint
	else:
		saved_game_state = init_game_state.duplicate(true)
	Main.can_open_menu = false
	whole_scene.set_castle_scene("room")
	player.global_position = Vector2(-1000000, -10000000)
	warrior.global_position = Vector2(-1000000, -10000000)
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

func _on_goal_body_entered(body: Node2D) -> void:
	if body.is_in_group("players"):
		player_cam.queue_free()
		player.queue_free()
		for node in Global.get_valid_nodes_in_group("killzone"):
			node.queue_free()
		spawn_bird.queue_free()
		bird_audio.queue_free()
		get_tree().paused = true
		$Story.show()
		$Story.next_step()
