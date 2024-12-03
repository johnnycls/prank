extends Node2D

@onready var collision_shape = $CollisionShape2D

@export var player: CharacterBody2D
@export var revolution: int = 9223372036854775807
@export var total_length: float = 5000

var current_revolution: int = 0

func _ready() -> void:
	collision_shape.shape.size = Vector2(total_length, 1000000000000)

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("players"):
		if body.global_position.x<global_position.x:
			if current_revolution > 0:
				current_revolution -= 1
				body.teleport(Vector2(global_position.x + total_length/2, body.global_position.y))
		else:
			if current_revolution < revolution:
				current_revolution += 1
				body.teleport(Vector2(global_position.x - total_length/2, body.global_position.y))
