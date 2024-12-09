extends Node2D

var bird_scene = preload("res://characters/bird.tscn")

@onready var game = get_parent()

@export var player: CharacterBody2D

func max_spawn_interval() -> float:
	return max(1.0 - game.current_distance() * 0.8 / 5000000, 0.2)
func min_spawn_interval() -> float:
	return max(0.75 - game.current_distance() * 0.6 / 5000000, 0.15)
func concurrent_poop() -> int:
	return min(ceil(game.current_distance()/250000), 20)
func max_shoot_time() -> float:
	return max(0.75 - game.current_distance() * 0.5 / 5000000, 0.25)
func min_shoot_time() -> float:
	return max(0.5 - game.current_distance() * 0.35 / 5000000, 0.15)

func _ready() -> void:
	_create_spawn_timer()

func _create_spawn_timer():
	var spawn_timer = Timer.new()
	add_child(spawn_timer)
	spawn_timer.one_shot = true
	spawn_timer.timeout.connect(func():
		_spawn()
		spawn_timer.queue_free()
	)
	var random_interval = randf_range(min_spawn_interval(), max_spawn_interval())
	spawn_timer.start(random_interval)
	
func _spawn():
	var bird = bird_scene.instantiate()
	var left_or_right = 1 if randf() < 0.3 else -1
	var start_x = player.global_position.x + left_or_right * 1920 * 3
	var end_x = player.global_position.x - left_or_right * 1920 * 2
	var start_y = randf_range(-2000, -1500)
	var end_y = randf_range(-2000, -1500)
	
	var direction = Vector2(start_x, start_y).direction_to(Vector2(end_x, end_y))
	bird.init(Vector2(start_x, start_y), direction, randf_range(4000, 4500), concurrent_poop(), min_shoot_time(), max_shoot_time())
	add_child(bird)
	_create_spawn_timer()
