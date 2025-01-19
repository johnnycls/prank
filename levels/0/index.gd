extends Node2D

@export var level_num = 0

var game = preload("res://levels/0/game.tscn")
var story = preload("res://levels/0/story.tscn")

var scene

var init_game_state = {
	"checkpoint": 0,
}
var saved_game_state
var current_game_state

func change_scene(_scene):
	if Global.is_node_valid(scene):
		scene.queue_free()
	scene = _scene.instantiate()
	add_child.call_deferred(scene)

func _ready() -> void:
	if Main.progress.has(str(level_num)):
		saved_game_state = Main.progress[str(level_num)]
		init_game_state.checkpoint = saved_game_state.checkpoint
	else:
		saved_game_state = init_game_state.duplicate(true)
	change_scene(story)
	scene.ended.connect(_on_story_ended)
	
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

func _on_story_ended():
	change_scene(game)
	scene.ended.connect(_on_game_ended)
	
func _on_game_ended():
	win()
