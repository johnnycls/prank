extends Node2D

signal ended

@export var level_num = 2

var start_pos = Vector2(22800, 735)

@onready var player = $Player
@onready var warrior = $Warrior
@onready var player_cam = $PlayerFollowingCamera
@onready var whole_scene = $WholeScene
@onready var spawn_bird = $SpawnBird
@onready var bird_audio = $BirdAudio

func _start() -> void:
	player.global_position = start_pos
	warrior.global_position.x = player.global_position.x - 1000
	player_cam.global_position.x = player.global_position.x
	player.init()

func _ready() -> void:
	whole_scene.set_castle_scene("outside")
	whole_scene.init(player_cam)
	_start()

func lose() -> void:
	_start()

func _on_player_dead() -> void:
	lose()

func _on_player_left_screen() -> void:
	lose()

func _on_goal_body_entered(body: Node2D) -> void:
	if body.is_in_group("players"):
		ended.emit()
