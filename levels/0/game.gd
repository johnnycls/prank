extends Node2D

signal ended

var goal_scene = preload("res://levels/0/goal.tscn")

@export var goal_position: Vector2 = Vector2(11000, 750)

@onready var player = $Player
@onready var whole_scene = $WholeScene

var goal

func _start() -> void:
	player.init()

func _ready() -> void:
	whole_scene.set_castle_scene("outside")

func lose() -> void:
	_start()

func _on_player_dead() -> void:
	lose()

func _on_player_left_screen() -> void:
	lose()

func _on_whole_scene_castle_changed_scene(scene: String) -> void:
	if scene=="kitchen":
		goal = goal_scene.instantiate()
		goal.position = goal_position
		goal.player_enter.connect(ended.emit)
		add_child(goal)
	elif Global.is_node_valid(goal):
		goal.queue_free()
		goal = null
