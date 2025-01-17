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
	for node in Global.get_valid_nodes_in_group("poop"):
		node.queue_free()
	for node in Global.get_valid_nodes_in_group("birds"):
		node.queue_free()
	player.init()

func _on_player_dead() -> void:
	_start()
	
func _on_player_left_screen() -> void:
	_start()

func _on_trap_body_entered(body: Node2D) -> void:
	if body.is_in_group("players"):
		ended.emit()
