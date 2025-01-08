extends Node2D

var bird_scene = preload("res://characters/bird.tscn")

@onready var game = get_parent()

@export var player: CharacterBody2D

var enabled: bool = true

func max_spawn_interval() -> float:
	return 5
func min_spawn_interval() -> float:
	return 3
func concurrent_poop() -> int:
	return 1
func max_shoot_time() -> float:
	return 2
func min_shoot_time() -> float:
	return 1.5

func _ready() -> void:
	_create_spawn_timer()

func _create_spawn_timer():
	if enabled:
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
	var left_or_right = 1 if randf() < 0.5 else -1
	var start_x = player.global_position.x + left_or_right * 1920 * 3
	var end_x = player.global_position.x - left_or_right * 1920 * 3
	var start_y = randf_range(-2000, -1500)
	var end_y = randf_range(-2000, -1500)
	
	var direction = Vector2(start_x, start_y).direction_to(Vector2(end_x, end_y))
	bird.init(Vector2(start_x, start_y), direction, randf_range(-500, 1000) if left_or_right==1 else randf_range(3500, 4000), concurrent_poop(), min_shoot_time(), max_shoot_time())
	add_child(bird)
	_create_spawn_timer()
