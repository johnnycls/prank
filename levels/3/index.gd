extends Node2D

var man_scene = preload("res://characters/man_catch.tscn")

@export var level_num = 3
@export var checkpoint_pos: Dictionary = {
	0: Vector2(50500, 740),
}

@onready var player = $Game/Player
@onready var player_cam = $Game/PlayerFollowingCamera
@onready var whole_scene = $WholeScene
@onready var spawn_bird = $Game/SpawnBird
@onready var bird_audio = $Game/BirdAudio
@onready var goal = $Game/Goal

var man

var init_game_state = {
	"checkpoint": 0,
}
var saved_game_state
var current_game_state

func start_story() -> void:
	Main.can_open_menu = false
	for poop in Global.get_valid_nodes_in_group("poop"):
		poop.queue_free()
	$Game.hide()
	player.global_position = Vector2(-100000, -100000)
	player_cam.enabled = false
	get_tree().paused = true
	$Story.show()
	$Story.next_step()

func _start() -> void:
	$Game.show()
	current_game_state = init_game_state.duplicate(true)
	player.global_position = checkpoint_pos[int(init_game_state.get("checkpoint", 0))]
	player_cam.global_position.x = player.global_position.x
	player_cam.enabled = true
	player.init()
	player.show()
	if Global.is_node_valid(man):
		man.global_position.y = player.global_position.y
		man.global_position.x = man.global_position.x - 500
		man.player = player
	player_cam.enabled = true
	whole_scene.init(player_cam)
	Main.can_open_menu = true

func _ready() -> void:
	if Main.progress.has(str(level_num)):
		saved_game_state = Main.progress[str(level_num)]
		init_game_state.checkpoint = saved_game_state.checkpoint
	else:
		saved_game_state = init_game_state.duplicate(true)
	whole_scene.set_castle_scene("outside")
	start_story()

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
	elif times==1:
		get_tree().paused = false
		$Story.hide()
		man = man_scene.instantiate()
		$Game.add_child(man)
		_start()
	else:
		win()

func _on_player_left_screen() -> void:
	lose()

func _on_goal_body_entered(body: Node2D) -> void:
	if body.is_in_group("players"):
		goal.queue_free()
		start_story()

func _on_goal_2_body_entered(body: Node2D) -> void:
	if body.is_in_group("players"):
		$Game.queue_free()
		start_story()
