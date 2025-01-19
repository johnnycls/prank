extends Node2D

signal ended

@onready var player = $Player
@onready var warrior = $Warrior

func _ready() -> void:
	_start()

func _start() -> void:
	for node in Global.get_valid_nodes_in_group("moving_objects"):
		node.queue_free()
	player.global_position = Vector2(-1820, -150)
	warrior.global_position = Vector2(1820, -150)
	player.init()
	warrior.init()

func _on_player_dead() -> void:
	_start()

func _on_warrior_died() -> void:
	ended.emit()
