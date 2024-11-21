extends Node2D

var story_scene = preload("res://levels/0/story.tscn")

@export var level_num = 0
@export var checkpoint_pos: Dictionary = {
	0: Vector2(-700,60),
}

@onready var player = $Player
@onready var enemy = $Enemy

var init_game_state = {
	"checkpoint": 0,
}
var saved_game_state
var current_game_state

func _start() -> void:
	current_game_state = init_game_state.duplicate(true)
	player.position = checkpoint_pos[int(init_game_state.get("checkpoint", 0))]
	enemy.position = Vector2(0,0)
	enemy.init()
	player.init()

func _ready() -> void:
	if Main.progress.has(level_num):
		saved_game_state = Main.progress[level_num]
		init_game_state.checkpoint = saved_game_state.checkpoint
	else:
		saved_game_state = init_game_state.duplicate(true)
	Main.story_ended.connect(_on_story_ended)
	Main.start_story(story_scene.instantiate())
	
func _on_story_ended() -> void:
	_start()

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
