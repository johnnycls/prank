extends Node2D

@onready var collision_shape = $CollisionShape2D

@export var player_following_cam: Camera2D
@export var revolution: int = 2147483647
@export var total_length: float = 5000

var current_revolution: int = 0

func init():
	current_revolution = 0

func _ready() -> void:
	collision_shape.shape.size = Vector2(total_length, 5000)

func _on_body_exited(body: Node2D) -> void:
	if player_following_cam and body.is_in_group("players"):
		if body.global_position.x<global_position.x:
			if current_revolution > 0:
				current_revolution -= 1
				body.global_position.x += total_length
				player_following_cam.global_position.x += total_length
				for node in Global.get_valid_nodes_in_group("moving_objects"):
					node.global_position.x += total_length
		else:
			if current_revolution < revolution:
				current_revolution += 1
				body.global_position.x -= total_length
				player_following_cam.global_position.x -= total_length
				for node in Global.get_valid_nodes_in_group("moving_objects"):
					node.global_position.x -= total_length
