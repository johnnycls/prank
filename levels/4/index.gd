extends Node2D

@export var level_num = 4

var story1 = preload("res://levels/4/story1.tscn")
var story2 = preload("res://levels/4/story2.tscn")
var story3 = preload("res://levels/4/story3.tscn")
var story4 = preload("res://levels/4/story4.tscn")
var story5 = preload("res://levels/4/story5.tscn")

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
	change_scene(story1)
	scene.ended.connect(_on_story1_ended)
	
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

func _on_story1_ended():
	change_scene(story2)
	scene.ended.connect(_on_story2_ended)
	
func _on_story2_ended():
	change_scene(story3)
	scene.ended.connect(_on_story3_ended)
	
func _on_story3_ended():
	change_scene(story4)
	scene.ended.connect(_on_story4_ended)
	
func _on_story4_ended():
	change_scene(story5)
	scene.ended.connect(_on_story5_ended)
	
func _on_story5_ended():
	win()
