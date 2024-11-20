extends Node2D

var food_scene = preload("res://objects/food.tscn")

@export var respawn_time: float = 10.0
@export var hungry_point: float = 10

var food

func _spawn_food() -> void:
	food = food_scene.instantiate()
	food.eaten.connect(func(eaten_by): 
		if eaten_by.is_in_group("players"):
			_eaten_by_player()
		elif eaten_by.is_in_group("enemies"):
			_eaten_by_enemy(eaten_by)
	)
	add_child(food)

func _ready() -> void:
	_spawn_food()

func _eaten_by_player():
	food.queue_free()
	_respawn()

func _eaten_by_enemy(enemy):
	food.queue_free()
	enemy.eat_food(hungry_point)
	_respawn()

func _respawn() -> void:
	var timer = get_tree().create_timer(respawn_time)
	await timer.timeout
	_spawn_food()
