extends Node2D

var food_scene = preload("res://objects/food.tscn")

func max_spawn_interval() -> float:
	return 10
func min_spawn_interval() -> float:
	return 6

func _ready() -> void:
	_spawn()

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
	var food = food_scene.instantiate()
	food.eaten.connect(func():
		_create_spawn_timer())
	add_child(food)
