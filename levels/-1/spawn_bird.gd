extends Node2D

var bird_scene = preload("res://characters/bird.tscn")

@export var min_spawn_interval: float = 1.0
@export var max_spawn_interval: float = 1.5
@export var player: CharacterBody2D

func _ready() -> void:
	_create_spawn_timer()

func _create_spawn_timer():
	var spawn_timer = Timer.new()
	add_child(spawn_timer)
	spawn_timer.one_shot = true
	spawn_timer.timeout.connect(func():
		spawn()
		spawn_timer.queue_free()
	)
	var random_interval = randf_range(min_spawn_interval, max_spawn_interval)
	spawn_timer.start(random_interval)
	
func spawn():
	var bird = bird_scene.instantiate()
	var is_left = 1 if randf() < 0.2 else -1
	
	var start_x = player.global_position.x - is_left * 1920 * 2.1
	var end_x = player.global_position.x + is_left * 1920 * 2.1
	var start_y = randf_range(-2160, -1080)
	var end_y = randf_range(-2160, -1080)
	
	var direction = Vector2(start_x, start_y).direction_to(Vector2(end_x, end_y))
	bird.init(Vector2(start_x, start_y), direction)
	add_child(bird)
	_create_spawn_timer()
