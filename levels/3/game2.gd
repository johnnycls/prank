extends Node2D

signal ended

@onready var player = $Player
@onready var man = $Man
@onready var whole_scene = $WholeScene
@onready var cam = $PlayerFollowingCamera

func _ready() -> void:
	whole_scene.init(cam)
	_start()

func _start() -> void:
	player.global_position = Vector2(55000, 755)
	man.global_position = Vector2(52000, 755)
	player.init()
	cam.global_position = player.global_position

func _on_goal_body_entered(body: Node2D) -> void:
	if body.is_in_group("players"):
		ended.emit()

func _on_player_dead() -> void:
	_start()
	
func _on_player_left_screen() -> void:
	_start()
