extends Node2D

signal ended

@onready var player = $Player
@onready var player_cam = $PlayerFollowingCamera
@onready var whole_scene = $WholeScene

func _start() -> void:
	player.global_position = Vector2(10800,760)
	player_cam.global_position.x = player.global_position.x
	player.init()

func _ready() -> void:
	whole_scene.set_castle_scene("kitchen")
	whole_scene.init(player_cam)
	_start()

func lose() -> void:
	_start()

func _on_player_dead() -> void:
	lose()

func _on_player_left_screen() -> void:
	lose()

func _on_whole_scene_castle_changed_scene(scene: String) -> void:
	if scene=="room":
		ended.emit()	
