extends Node2D

signal ended

@onready var player = $Player
@onready var whole_scene = $WholeScene
@onready var cam = $PlayerFollowingCamera

func _ready() -> void:
	whole_scene.init(cam)
	whole_scene.set_house1_scene("outside")
	_start()

func _start() -> void:
	whole_scene.init(cam)
	whole_scene.set_castle_scene("outside")
	for node in Global.get_valid_nodes_in_group("poop"):
		node.queue_free()
	for node in Global.get_valid_nodes_in_group("birds"):
		node.queue_free()
	player.global_position = Vector2(74000, 755)
	cam.global_position.x = player.global_position.x
	player.init()
	
func _on_goal_body_entered(body: Node2D) -> void:
	if body.is_in_group("players"):
		ended.emit()

func _on_player_dead() -> void:
	_start()
	
func _on_player_left_screen() -> void:
	_start()
